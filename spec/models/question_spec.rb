require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question) }

  describe 'validations' do
    it { expect(question).to be_valid }

    context 'without text' do
      let(:question_without_text) { build(:question, text: nil) }
      it { expect(question_without_text).to be_invalid }
    end
  end

  describe 'associations' do
    it 'has many answers' do
      association = described_class.reflect_on_association(:answers)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end
end
