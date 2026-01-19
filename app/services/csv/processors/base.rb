module Csv
  module Processors
    class Base
      attr_reader :batch, :now

      def initialize(batch)
        @batch = batch
        @now = Time.current
      end

      def execute
        process_batch

        mapped_return
      end

      private

      def process_batch
        raise NotImplementedError, "#{self.class} deve implementar #process_batch"
      end

      def mapped_return
        nil
      end

      def bulk_upsert(model_class, records, unique_keys:, returning: nil)
        return if records.empty?

        options = { unique_by: unique_keys }
        options[:returning] = returning if returning.present?

        model_class.upsert_all(records, **options)
      end
    end
  end
end
