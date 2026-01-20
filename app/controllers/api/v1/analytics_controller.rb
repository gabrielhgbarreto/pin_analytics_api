module Api
  module V1
    class AnalyticsController < ApplicationController
      def nps
        filters = filter_params

        calculator = Analytics::Nps::Calculator.new(filters)

        render json: { nps: calculator.execute }, status: :ok
      end

      private

      def filter_params
        params.permit(:department_id, :tenure)
      end
    end
  end
end
