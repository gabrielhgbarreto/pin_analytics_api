require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:job) { create(:job) }

  describe 'validations' do
    it { expect(job).to be_valid }

    context 'without title' do
      let(:job_without_title) { build(:job, title: nil) }
      it { expect(job_without_title).to be_invalid }
    end

    context 'without function_name' do
      let(:job_without_function) { build(:job, function_name: nil) }
      it { expect(job_without_function).to be_invalid }
    end
  end

  describe 'associations' do
    it 'has many employees' do
      association = described_class.reflect_on_association(:employees)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:restrict_with_error)
    end
  end
end
