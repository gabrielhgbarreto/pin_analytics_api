require 'rails_helper'

RSpec.describe Csv::Processors::Questions do
  subject(:processor) { described_class.new(batch) }

  let(:file_path) { Rails.root.join('spec/fixtures/files/external_data.csv') }
  let(:batch) { CSV.read(file_path, headers: true, col_sep: ';').map(&:to_h) }

  describe '#execute' do
    let(:result) { processor.execute }

    it 'upserts questions and returns a mapping hash' do
      expect { result }.to change(Question, :count).by(8)

      expect(result.size).to eq(8)
      result.each do |_, values|
        expect(values).to be_a(Integer)
      end
    end
  end
end
