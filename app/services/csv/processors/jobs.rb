module Csv
  module Processors
    class Jobs < Base
      CSV_FIELDS = { title: "cargo", function_name: "funcao" }.freeze

      attr_reader :job_cache

      private

      def process_batch
        records = extract_bulk

        @job_cache = bulk_upsert(
          Job,
          records,
          unique_keys: CSV_FIELDS.keys,
          returning: [:id, :title, :function_name]
        )
      end

      def extract_bulk
        batch.each_with_object({}) do |row, hash|
          mapped_row = CSV_FIELDS.transform_values { |header| row[header] }.merge(created_at: now, updated_at: now)

          unique_key = mapped_row.values_at(*CSV_FIELDS.keys)
          hash[unique_key] ||= mapped_row
        end.values
      end

      def mapped_return
        job_cache.rows.to_h do |id, title, function_name|
          [ [title, function_name], id ]
        end
      end
    end
  end
end
