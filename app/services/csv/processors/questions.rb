module Csv
  module Processors
    class Questions < Base
      CSV_HEADERS_REGEX = /^(?:coment[áa]rios?|\[aberta\])\s*[-–]?\s*(.+)/i.freeze

      attr_reader :questions_cache, :return

      private

      def process_batch
        records = extract_headers

        @questions_cache = bulk_upsert(
          Question,
          records,
          unique_keys: [:text],
          returning: [:id, :text]
        )
      end

      def extract_headers
        return [] if batch.empty?

        headers = batch.first.keys.filter_map { |h| h[CSV_HEADERS_REGEX, 1] }

        prepare_records(headers)
      end

      def prepare_records(headers)
        headers.map do |header_text|
          {
            text: header_text,
            active: true,
            created_at: now,
            updated_at: now
          }
        end
      end

      def mapped_return
        @return ||= questions_cache.rows.to_h do |id, text|
          [ text, id ]
        end
      end
    end
  end
end
