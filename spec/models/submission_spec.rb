require 'rails_helper'

RSpec.describe Submission, type: :model do
  let(:submission) { create(:submission) }

  describe 'validations' do
    it { expect(submission).to be_valid }

    context 'without responded_at' do
      let(:submission_without_date) { build(:submission, responded_at: nil) }
      it { expect(submission_without_date).to be_invalid }
    end
  end

  describe 'associations' do
    it 'belongs to employee' do
      association = described_class.reflect_on_association(:employee)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many answers' do
      association = described_class.reflect_on_association(:answers)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end
end
