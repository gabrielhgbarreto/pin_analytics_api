module Csv
  module Processors
    class Answers < Base
      CSV_FIELDS = {
        name:            "nome",
        email:           "email",
        corporate_email: "email_corporativo",
        gender:          "genero",
        generation:      "geracao",
        location:        "localidade",
        tenure:          "tempo_de_empresa"
      }.freeze

      attr_reader :saved_questions, :saved_submissions

      def initialize(batch, saved_questions, saved_submissions)
        super(batch)
        @saved_questions = saved_questions
        @saved_submissions = saved_submissions
      end

      private

      def process_batch
        records = extract_bulk

        bulk_upsert(
          Answer,
          records,
          unique_keys: [ :submission_id, :question_id ]
        )
      end

      def extract_bulk
        batch.flat_map do |row|
          submission_id = find_submission_id(row)

          next [] unless submission_id

          saved_questions.filter_map do |question, id|
            build_record(row, question, id, submission_id)
          end
        end
      end

      def find_submission_id(row)
        response_date = row["Data da Resposta"]
        return if response_date.blank?

        raw_date = Date.strptime(response_date, "%d/%m/%Y")
        treated_response_date = Time.utc(raw_date.year, raw_date.month, raw_date.day)

        submission_key = [ row["email_corporativo"], treated_response_date ]
        saved_submissions[submission_key]
      end

      def build_record(row, question, question_id, submission_id)
        answers = row.select { |key, _| key.to_s.end_with?(question) }
        score_value = answers.delete(question).to_i
        text_value = answers.values.first == "-" ? nil : answers.values.first

        {
          score_value: score_value,
          text_value: text_value,
          submission_id: submission_id,
          question_id: question_id,
          created_at: now,
          updated_at: now
        }
      end
    end
  end
end
