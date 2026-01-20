module Csv
  module Processors
    class Submissions < Base
      CSV_FIELDS = { responded_at: "Data da Resposta" }.freeze

      attr_reader :saved_employees, :submission_cache

      def initialize(batch, saved_employees)
        super(batch)
        @saved_employees = saved_employees
      end

      private

      def process_batch
        records = extract_bulk

        @submission_cache = bulk_upsert(
          Submission,
          records,
          unique_keys: [ :employee_id, :responded_at ],
          returning: [ :id, :employee_id, :responded_at ]
        )
      end

      def extract_bulk
        batch.filter_map do |row|
          employee_key = row["email_corporativo"]
          employee_id = saved_employees[employee_key]

          next unless employee_id

          build_record(row, employee_id)
        end
      end

      def build_record(row, employee_id)
        attributes = CSV_FIELDS.transform_values { |csv_header| row[csv_header] }

        attributes.merge(
          employee_id: employee_id,
          created_at: now,
          updated_at: now
        )
      end

      def mapped_return
        employees_by_id = saved_employees.invert

        submission_cache.rows.to_h do |id, employee_id, responded_at|
          corporate_email = employees_by_id[employee_id]

          [ [ corporate_email, responded_at ], id ]
        end
      end
    end
  end
end
