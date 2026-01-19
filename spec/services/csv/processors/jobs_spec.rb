require 'rails_helper'

RSpec.describe Csv::Processors::Jobs do
  subject(:processor) { described_class.new(batch) }

  let(:file_path) { Rails.root.join('spec/fixtures/files/external_data.csv') }
  let(:batch) { CSV.read(file_path, headers: true, col_sep: ';').map(&:to_h) }

  describe '#execute' do
    let(:result) { processor.execute }

    it 'upserts jobs and returns a mapping hash' do
      expect { result }.to change(Job, :count).by(2)

      expect(result.size).to eq(2)
      expect(result[["estagiário", "profissional"]]).to be_a(Integer)
      expect(result[["analista", "profissional"]]).to be_a(Integer)
    end
  end
end
