module Api
  module V1
    class CsvImportsController < ApplicationController
      def create
        if import_params[:csv_url].blank?
          return render json: { error: 'URL do CSV é obrigatória' }, status: :unprocessable_entity
        end

        begin
          Csv::ImportJob.perform_later(import_params[:csv_url])

          render json: { message: 'Importação concluída com sucesso' }, status: :ok
        rescue StandardError => e
          render json: { error: "Falha na importação: #{e.message}" }, status: :internal_server_error
        end
      end

      private

      def import_params
        params.require(:import).permit(:csv_url)
      end
    end
  end
end
