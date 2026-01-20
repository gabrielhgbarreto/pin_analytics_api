module Csv
  module Processors
    class Departments < Base
      CSV_FIELDS = [
        { kind: "n0_empresa" },
        { kind: "n1_diretoria" },
        { kind: "n2_gerencia" },
        { kind: "n3_coordenacao" },
        { kind: "n4_area" }
      ].freeze

      UNIQUE_KEYS = [ :name, :ancestry ].freeze

      attr_reader :department_cache

      def initialize(batch)
        super(batch)
        @department_cache = {}
      end

      private

      def process_batch
        bulk_in_buckets = extract_bulk_buckets

        bulk_in_buckets.keys.sort.each do |level|
          bulk_per_level = bulk_in_buckets[level]
          next if bulk_per_level.empty?

          mapped_bulk = prepare_records_for_insert(bulk_per_level)

          result = bulk_upsert(
            Department,
            mapped_bulk,
            unique_keys: UNIQUE_KEYS,
            returning: [ :id, :name, :ancestry ]
          )

          update_cache(result)
        end
      end

      def extract_bulk_buckets
        buckets = CSV_FIELDS.each_index.with_object({}) { |index, hash| hash[index] = {} }

        batch.each do |row|
          parent_path = nil

          CSV_FIELDS.each_with_index do |field, level|
            department_name = row[field[:kind]]
            break if department_name.blank?

            current_path = level == 0 ? department_name : "#{parent_path}/#{department_name}"

            buckets[level][current_path] ||= {
              name: department_name,
              kind: Department::HIERARCHY_LEVELS[field[:kind]],
              parent_path_key: parent_path,
              created_at: now,
              updated_at: now
            }

            parent_path = current_path
          end
        end

        buckets
      end

      def prepare_records_for_insert(bulk)
        bulk.map do |path, attributes|
          parent_key = attributes.delete(:parent_path_key)
          parent_data = @department_cache[parent_key]

          if parent_data
            parent_ancestry = parent_data[:ancestry]
            parent_id = parent_data[:id]

            attributes[:ancestry] = parent_ancestry.present? ? "#{parent_ancestry}/#{parent_id}" : "#{parent_id}"
          else
            attributes[:ancestry] = nil
          end

          attributes
        end
      end

      def update_cache(upsert_results)
        parent_id_to_path_map = @department_cache.each_with_object({}) do |(path, data), hash|
          hash[data[:id]] = path
        end

        upsert_results.each do |row|
          parent_id = row["ancestry"]&.split("/")&.last&.to_i
          current_path_key = nil

          if parent_id && parent_id > 0
            parent_path_str = parent_id_to_path_map[parent_id]
            current_path_key = "#{parent_path_str}/#{row['name']}" if parent_path_str
          else
            current_path_key = row["name"]
          end

          if current_path_key
            @department_cache[current_path_key] = {
              id: row["id"],
              ancestry: row["ancestry"]
            }
          end
        end
      end

      def mapped_return
        department_cache.to_h do |path, data|
          last_name = path.split("/").last
          [ last_name, data[:id] ]
        end
      end
    end
  end
end
