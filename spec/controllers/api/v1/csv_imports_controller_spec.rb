require 'rails_helper'

RSpec.describe Api::V1::CsvImportsController, type: :request do
  describe 'POST /api/v1/csv_imports' do
    let(:valid_params) { { csv_url: 'https://example.com/data.csv' } }
    let(:invalid_params) { { csv_url: '' } }

    context 'with valid parameters' do
      before do
        allow(Csv::ImportJob).to receive(:perform_later)
      end

      it 'enqueues the import job and returns success' do
        post '/api/v1/csv_imports', params: valid_params

        expect(Csv::ImportJob).to have_received(:perform_later).with('https://example.com/data.csv')
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Importação concluída com sucesso')
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity when csv_url is missing' do
        post '/api/v1/csv_imports', params: invalid_params

        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)['error']).to eq('Falha na importação: param is missing or the value is empty or invalid: csv_url')
      end
    end

    context 'when an error occurs' do
      before do
        allow(Csv::ImportJob).to receive(:perform_later).and_raise(StandardError, 'Job Error')
      end

      it 'returns internal server error' do
        post '/api/v1/csv_imports', params: valid_params

        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)['error']).to eq('Falha na importação: Job Error')
      end
    end
  end
end
