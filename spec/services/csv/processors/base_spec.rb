require 'rails_helper'

RSpec.describe Csv::Processors::Base do
  subject(:processor) { described_class.new(batch) }

  let(:batch) { [{ 'some' => 'data' }] }

  describe '#initialize' do
    it 'initializes with a batch' do
      expect(processor.batch).to eq(batch)
    end
  end

  describe '#execute' do
    it 'raises NotImplementedError' do
       expect { processor.execute }.to raise_error(NotImplementedError, "#{described_class} deve implementar #process_batch")
    end
  end
end
