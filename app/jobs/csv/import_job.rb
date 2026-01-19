module Csv
  class ImportJob < ApplicationJob
    def perform(csv_url)
      Csv::Handler.new(csv_url).execute
    end
  end
end
