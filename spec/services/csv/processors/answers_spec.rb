require 'rails_helper'

RSpec.describe Csv::Processors::Answers do
  subject(:processor) { described_class.new(batch, saved_questions, saved_submissions) }

  let(:file_path) { Rails.root.join('spec/fixtures/files/external_data.csv') }
  let(:batch) { CSV.read(file_path, headers: true, col_sep: ';').map(&:to_h) }

  let(:saved_jobs) { Csv::Processors::Jobs.new(batch).execute }
  let(:saved_departments) { Csv::Processors::Departments.new(batch).execute }
  let(:saved_employees) { Csv::Processors::Employees.new(batch, saved_jobs, saved_departments).execute }
  let(:saved_questions) { Csv::Processors::Questions.new(batch).execute }
  let(:saved_submissions) { Csv::Processors::Submissions.new(batch, saved_employees).execute }

  describe '#execute' do
    let(:result) { processor.execute }

    it 'upserts answers linking submissions and questions' do
      expect { result }.to change(Answer, :count).by(40)
    end
  end
end
