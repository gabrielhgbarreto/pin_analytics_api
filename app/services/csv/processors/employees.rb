module Csv
  module Processors
    class Employees < Base
      CSV_FIELDS = {
        name:            "nome",
        email:           "email",
        corporate_email: "email_corporativo",
        gender:          "genero",
        generation:      "geracao",
        location:        "localidade",
        tenure:          "tempo_de_empresa"
      }.freeze

      DEPARTMENT_COLUMN = "n4_area".freeze

      attr_reader :saved_jobs, :saved_departments, :employee_cache

      def initialize(batch, saved_jobs, saved_departments)
        super(batch)
        @saved_jobs = saved_jobs
        @saved_departments = saved_departments
      end

      private

      def process_batch
        records = extract_bulk

        @employee_cache = bulk_upsert(
          Employee,
          records,
          unique_keys: [ :corporate_email ],
          returning: [ :id, :corporate_email ]
        )
      end

      def extract_bulk
        batch.filter_map do |row|
          associations = extract_associations(row)
          job_id = associations[:job_id]
          department_id = associations[:department_id]

          next unless job_id && department_id

          build_record(row, job_id, department_id)
        end
      end

      def extract_associations(row)
        job_key = [ row["cargo"], row["funcao"] ]
        job_id = saved_jobs[job_key]

        department_name = row[DEPARTMENT_COLUMN]
        department_id = saved_departments[department_name]

        { job_id:, department_id: }
      end

      def build_record(row, job_id, department_id)
        attributes = CSV_FIELDS.transform_values { |csv_header| row[csv_header] }

        if (raw_tenure = attributes[:tenure].downcase).present?
          attributes[:tenure] = Employee::CSV_TENURE_MAPPING[raw_tenure]
        end

        attributes.merge(
          job_id: job_id,
          department_id: department_id,
          created_at: now,
          updated_at: now
        )
      end

      def mapped_return
        employee_cache.rows.to_h do |id, corporate_email|
          [ corporate_email, id ]
        end
      end
    end
  end
end
