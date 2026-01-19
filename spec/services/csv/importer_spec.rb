require 'rails_helper'

RSpec.describe Csv::Importer do
  subject(:importer) { described_class.new(tempfile) }

  let(:tempfile) { File.open(Rails.root.join('spec/fixtures/files/external_data.csv')) }
  let(:handler) { double('Csv::Processors::Handler') }

  before do
    stub_const('Csv::Processors::Handler', Class.new)
    allow(Csv::Processors::Handler).to receive(:new).and_return(handler)
    allow(handler).to receive(:execute)
  end

  after do
    tempfile.close
  end

  describe '#execute' do
    let(:result) { importer.execute }

    it 'reads the csv and processes rows via handler' do
      result

      expect(handler).to have_received(:execute) do |batch|
        expect(batch).to be_an(Array)
        expect(batch.size).to eq(5)
        expect(batch.first['nome']).to eq('Demo 001')
        expect(batch.first['email']).to eq('demo001@pinpeople.com.br')
      end
    end

    it 'processes in batches' do
      stub_const("#{described_class}::BATCH_SIZE", 2)
      result

      expect(handler).to have_received(:execute).exactly(3).times
    end
  end
end
