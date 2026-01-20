module Api
  module V1
    class CsvImportsController < ApplicationController
      def create
        Csv::ImportJob.perform_later(csv_url)

        render json: { message: 'Importação concluída com sucesso' }, status: :ok
      rescue StandardError => e
        render json: { error: "Falha na importação: #{e.message}" }, status: :internal_server_error
      end

      private

      def csv_url
        params.require(:csv_url)
      end
    end
  end
end
