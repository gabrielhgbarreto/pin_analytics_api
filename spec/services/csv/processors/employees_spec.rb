require 'rails_helper'

RSpec.describe Csv::Processors::Employees do
  subject(:processor) { described_class.new(batch, saved_jobs, saved_departments) }

  let(:file_path) { Rails.root.join('spec/fixtures/files/external_data.csv') }
  let(:batch) { CSV.read(file_path, headers: true, col_sep: ';').map(&:to_h) }

  let(:saved_jobs) { Csv::Processors::Jobs.new(batch).execute }
  let(:saved_departments) { Csv::Processors::Departments.new(batch).execute }

  describe '#execute' do
    let(:result) { processor.execute }

    it 'upserts employees and returns a mapping hash' do
      expect { result }.to change(Employee, :count).by(5)

      expect(result.size).to eq(5)
      [1, 2, 3, 4, 5].each do |id|
        expect(result["demo00#{id}@pinpeople.com.br"]).to be_a(Integer)
      end
    end
  end
end
