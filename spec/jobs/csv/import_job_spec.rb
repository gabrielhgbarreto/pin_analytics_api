require 'rails_helper'

RSpec.describe Csv::ImportJob, type: :job do
  describe '#perform' do
    let(:csv_url) { 'https://example.com/data.csv' }
    let(:handler) { instance_double(Csv::Handler) }

    before do
      allow(Csv::Handler).to receive(:new).with(csv_url).and_return(handler)
      allow(handler).to receive(:execute)
    end

    it 'calls the Csv::Handler service with the provided URL' do
      described_class.perform_now(csv_url)

      expect(Csv::Handler).to have_received(:new).with(csv_url)
      expect(handler).to have_received(:execute)
    end
  end
end
