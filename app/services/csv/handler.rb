module Csv
  class Handler
    attr_reader :csv_url

    def initialize(csv_url)
      @csv_url = csv_url
    end

    def execute
      return if csv_url.blank?

      process
    end

    private

    def process
      tempfile = stream_to_tempfile
      importer(tempfile)
    end

    def stream_to_tempfile
      downloader = Csv::Downloader.new(csv_url)
      downloader.execute
    end

    def importer(tempfile)
      importer = Csv::Importer.new(tempfile)
      importer.execute
    end
  end
end
