module Csv
  module Processors
    class Handler
      attr_reader :batch

      def execute(batch)
        ApplicationRecord.transaction do
          @batch = batch
          process_batch_in_cascade
        end
      end

      private

      def process_batch_in_cascade
        saved_jobs        = jobs_processor
        saved_departments = departments_processor
        saved_employees   = employees_processor(saved_jobs, saved_departments)
        saved_questions   = questions_processor
        saved_submissions = submissions_processor(saved_employees)
        answers_processor(saved_questions, saved_submissions)
      end

      def jobs_processor
        processor = Csv::Processors::Jobs.new(batch)
        processor.execute
      end

      def departments_processor
        processor = Csv::Processors::Departments.new(batch)
        processor.execute
      end

      def employees_processor(saved_jobs, saved_departments)
        processor = Csv::Processors::Employees.new(batch, saved_jobs, saved_departments)
        processor.execute
      end

      def questions_processor
        @questions_processor ||= Csv::Processors::Questions.new(batch)

        return @questions_processor.execute unless @questions_processor.questions_cache
        @questions_processor.return
      end

      def submissions_processor(saved_employees)
        processor = Csv::Processors::Submissions.new(batch, saved_employees)
        processor.execute
      end

      def answers_processor(saved_questions, saved_submissions)
        processor = Csv::Processors::Answers.new(batch, saved_questions, saved_submissions)
        processor.execute
      end
    end
  end
end
