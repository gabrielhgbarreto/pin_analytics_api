require 'rails_helper'

RSpec.describe Department, type: :model do
  let(:department) { create(:department) }

  describe 'validations' do
    it { expect(department).to be_valid }

    context 'with name' do
      let(:department_without_name) { build(:department, name: nil) }
      it { expect(department_without_name).to be_invalid }
    end
  end

  describe 'associations' do
    it 'has many employees' do
      association = described_class.reflect_on_association(:employees)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:restrict_with_error)
    end
  end

  describe 'ancestry' do
    let(:child) { create(:department, parent: department) }

    it 'works with parent and children' do
      expect(child.parent).to eq(department)
      expect(department.children).to include(child)
    end
  end
end
