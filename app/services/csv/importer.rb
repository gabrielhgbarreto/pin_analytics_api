module Csv
  class Importer
    BATCH_SIZE = 100

    attr_reader :tempfile, :file_path

    def initialize(tempfile)
      @tempfile = tempfile
      @file_path = tempfile.path
    end

    def execute
      read_and_process
    end

    private

    def read_and_process
      batch = []

      CSV.foreach(@file_path, headers: true, col_sep: ';') do |row|
        batch << row.to_h

        if batch.size >= BATCH_SIZE
          process_batch(batch)
          batch.clear
        end
      end

      process_batch(batch) unless batch.empty?
    end

    def process_batch(batch)
      handler.execute(batch)
    end

    def handler
      @handler ||= Csv::Processors::Handler.new
    end
  end
end
