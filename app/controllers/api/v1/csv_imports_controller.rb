module Api
  module V1
    class CsvImportsController < ApplicationController
      def create
        csv_url = params[:csv_url]

        if csv_url.blank?
          return render json: { error: 'URL do CSV é obrigatória' }, status: :unprocessable_entity
        end

        begin
          Csv::ImportJob.perform_later(csv_url)

          render json: { message: 'Importação concluída com sucesso' }, status: :ok
        rescue StandardError => e
          render json: { error: "Falha na importação: #{e.message}" }, status: :internal_server_error
        end
      end
    end
  end
end
