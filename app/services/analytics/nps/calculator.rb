module Analytics
  module Nps
    class Calculator
      QUESTION_NAME = "eNPS".freeze

      attr_reader :department_id, :tenure

      def initialize(filters = {})
        @department_id = filters[:department_id]
        @tenure = filters[:tenure]&.to_i
      end

      def execute
        score_distribution = scope.group(:score_value).count
        calculate_nps(score_distribution)
      end

      private

      def scope
        current_scope = base_scope

        current_scope = apply_department_filter(current_scope) if department_id
        current_scope = apply_tenure_filter(current_scope) if mapped_tenure

        @scope ||= current_scope
      end

      def base_scope
        Answer.joins(:question, submission: :employee).where(questions: { text: QUESTION_NAME })
      end

      def apply_department_filter(current_scope)
        current_scope.where(employees: { department_id: department.subtree_ids })
      end

      def apply_tenure_filter(current_scope)
        current_scope.where(employees: { tenure: tenure })
      end

      def department
        @department ||= Department.find(department_id)
      end

      def mapped_tenure
        return unless tenure
        return true if tenure.in?(Employee.tenures.values)
        raise ArgumentError, "Tenure inválido: #{tenure}"
      end

      def calculate_nps(distribution)
        total_respondents = distribution.values.sum
        return 0 if total_respondents.zero?

        promoters = count_in_range(distribution, 9..10)
        detractors = count_in_range(distribution, 0..6)

        score = ((promoters - detractors).to_f / total_respondents) * 100

        score.round(2)
      end

      def count_in_range(distribution, range)
        distribution.select { |score, _| range.include?(score) }.values.sum
      end
    end
  end
end
