require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:answer) { create(:answer) }

  describe 'validations' do
    it { expect(answer).to be_valid }

    context 'without value' do
      let(:answer_without_value) { build(:answer, score_value: nil, text_value: nil) }
      it { expect(answer_without_value).to be_invalid }
    end

    context 'with text value only' do
      let(:answer_text) { build(:answer, score_value: nil, text_value: 'Some text') }
      it { expect(answer_text).to be_valid }
    end
  end

  describe 'associations' do
    it 'belongs to submission' do
      association = described_class.reflect_on_association(:submission)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to question' do
      association = described_class.reflect_on_association(:question)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
