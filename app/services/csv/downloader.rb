require 'net/http'

module Csv
  class Downloader
    attr_reader :csv_url

    def initialize(csv_url)
      # csv_url = https://raw.githubusercontent.com/pin-people/tech_playground/main/data.csv
      @csv_url = csv_url
    end

    def execute
      stream_to_tempfile
    end

    private

    def tempfile
      @tempfile ||= Tempfile.new(['import', '.csv']).binmode
    end

    def uri
      uri ||= URI.parse(csv_url)
    end

    def stream_to_tempfile
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new(uri)

        http.request(request) do |response|
          unless response.is_a?(Net::HTTPSuccess)
            raise "Falha no download do csv. Status: #{response.code}"
          end

          response.read_body do |chunk|
            tempfile.write(chunk)
          end
        end
      end

      tempfile.rewind
      tempfile
    end
  end
end
