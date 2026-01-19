require 'rails_helper'

RSpec.describe Csv::Handler do
  subject(:handler) { described_class.new(csv_url) }

  let(:csv_url) { 'https://example.com/file.csv' }
  let(:tempfile) { instance_double(Tempfile) }
  let(:downloader) { instance_double(Csv::Downloader) }
  let(:importer) { instance_double(Csv::Importer) }

  before do
    allow(Csv::Downloader).to receive(:new).and_return(downloader)
    allow(downloader).to receive(:execute).and_return(tempfile)
    allow(Csv::Importer).to receive(:new).and_return(importer)
    allow(importer).to receive(:execute)
  end

  describe '#execute' do
    let(:result) { handler.execute }

    context 'when csv_url is present' do
      it 'downloads and imports the csv' do
        result

        expect(Csv::Downloader).to have_received(:new).with(csv_url)
        expect(downloader).to have_received(:execute)
        expect(Csv::Importer).to have_received(:new).with(tempfile)
        expect(importer).to have_received(:execute)
      end
    end

    context 'when csv_url is blank' do
      let(:csv_url) { '' }

      it 'returns nil and does not trigger process' do
        expect(result).to be_nil
        expect(Csv::Downloader).not_to have_received(:new)
        expect(Csv::Importer).not_to have_received(:new)
      end
    end
  end
end
