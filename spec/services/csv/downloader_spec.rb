require 'rails_helper'
require 'net/http'

RSpec.describe Csv::Downloader do
  subject(:downloader) { described_class.new(url) }

  let(:url) { 'https://example.com/data.csv' }
  let(:csv_content) { "header1;header2\nvalue1;value2" }

  describe '#execute' do
    let(:result) { downloader.execute }

    let(:http) { instance_double(Net::HTTP) }
    let(:request) { instance_double(Net::HTTP::Get) }
    let(:response) { instance_double(Net::HTTPOK) }

    before do
      uri = URI.parse(url)
      allow(Net::HTTP).to receive(:start).with(uri.host, uri.port, use_ssl: true).and_yield(http)
      allow(Net::HTTP::Get).to receive(:new).with(uri).and_return(request)
      allow(http).to receive(:request).with(request).and_yield(response)
    end

    context 'when the request is successful' do
      before do
        allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        allow(response).to receive(:read_body).and_yield(csv_content)
      end

      it 'downloads content to a tempfile' do
        tempfile = result

        expect(tempfile).to be_a(File)
        expect(tempfile.read).to eq(csv_content)
      end
    end

    context 'when the request fails' do
      let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

      before do
        allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
      end

      it 'raises an error' do
        expect { result }.to raise_error(RuntimeError, /Falha no download do csv. Status: 404/)
      end
    end
  end
end
