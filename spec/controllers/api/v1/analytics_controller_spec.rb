require 'rails_helper'

RSpec.describe Api::V1::AnalyticsController, type: :request do
  describe 'GET /api/v1/analytics/nps' do
    let(:nps_score) { 50.0 }
    let(:calculator_double) { instance_double(Analytics::Nps::Calculator, execute: nps_score) }

    before do
      allow(Analytics::Nps::Calculator).to receive(:new).and_return(calculator_double)
    end

    context 'without parameters' do
      it 'returns http success and the nps score' do
        get '/api/v1/analytics/nps'

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['nps']).to eq(nps_score)

        expect(Analytics::Nps::Calculator).to have_received(:new)
      end
    end

    context 'with filtering parameters' do
      let(:params) { { department_id: '1', tenure: '2' } }

      it 'passes the filters to the calculator' do
        get '/api/v1/analytics/nps', params: params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['nps']).to eq(nps_score)

        expect(Analytics::Nps::Calculator).to have_received(:new) do |args|
          expect(args[:department_id]).to eq('1')
          expect(args[:tenure]).to eq('2')
        end
      end
    end
  end
end
