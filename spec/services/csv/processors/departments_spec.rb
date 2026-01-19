require 'rails_helper'

RSpec.describe Csv::Processors::Departments do
  subject(:processor) { described_class.new(batch) }

  let(:file_path) { Rails.root.join('spec/fixtures/files/external_data.csv') }
  let(:batch) { CSV.read(file_path, headers: true, col_sep: ';').map(&:to_h) }

  describe '#execute' do
    let(:result) { processor.execute }

    it 'upserts departments and returns a mapping hash' do
      expect { result }.to change(Department, :count).by(6)

      expect(result.size).to eq(6)
      result.each do |_, values|
        expect(values).to be_a(Integer)
      end
    end

    it 'associates ancestry correctly' do
      result
      executive_board = Department.find_by(name: 'diretoria a')
      expect(executive_board.children.first.name).to eq('gerência a1')
      expect(executive_board.root.name).to eq('empresa')
    end
  end
end
