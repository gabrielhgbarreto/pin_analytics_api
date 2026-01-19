require 'rails_helper'
require 'csv'

RSpec.describe Csv::Processors::Handler do
  subject(:handler) { described_class.new }

  let(:file_path) { Rails.root.join('spec/fixtures/files/external_data.csv') }
  let(:batch) { CSV.read(file_path, headers: true, col_sep: ';').map(&:to_h) }

  describe '#execute' do
    let(:result) { handler.execute(batch) }

    it 'processes the batch and persists all data correctly' do
      expect { result }
        .to change(Job, :count).by(2)
        .and change(Department, :count).by(6)
        .and change(Employee, :count).by(5)
        .and change(Question, :count).by(8)
        .and change(Submission, :count).by(5)
        .and change(Answer, :count).by(40)
    end

    it 'is idempotent (does not duplicate data on second run)' do
      handler.execute(batch)

      expect { result }
        .to change(Job, :count).by(0)
        .and change(Department, :count).by(0)
        .and change(Employee, :count).by(0)
        .and change(Question, :count).by(0)
        .and change(Submission, :count).by(0)
        .and change(Answer, :count).by(0)
    end

    context 'when an error occurs during processing' do
      before do
        allow(Csv::Processors::Employees).to receive(:new).and_raise(StandardError, 'Transaction Error')
      end

      it 'rolls back all database changes' do
        expect { result rescue nil }
          .to change(Job, :count).by(0)
          .and change(Department, :count).by(0)
      end
    end
  end
end
