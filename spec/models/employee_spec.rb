require 'rails_helper'

RSpec.describe Employee, type: :model do
  let(:employee) { create(:employee) }

  describe 'validations' do
    it { expect(employee).to be_valid }

    context 'without name' do
      let(:employee_without_name) { build(:employee, name: nil) }
      it { expect(employee_without_name).to be_invalid }
    end

    context 'without corporate_email' do
      let(:employee_without_email) { build(:employee, corporate_email: nil) }
      it { expect(employee_without_email).to be_invalid }
    end

    context 'with invalid corporate_email' do
      let(:employee_invalid_email) { build(:employee, corporate_email: 'invalid') }
      it { expect(employee_invalid_email).to be_invalid }
    end

    context 'with duplicate corporate_email' do
      let(:employee_duplicate) { build(:employee, corporate_email: employee.corporate_email) }
      it { expect(employee_duplicate).to be_invalid }
    end
  end

  describe 'associations' do
    it 'belongs to department' do
      association = described_class.reflect_on_association(:department)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to job' do
      association = described_class.reflect_on_association(:job)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many submissions' do
      association = described_class.reflect_on_association(:submissions)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end
end
