# frozen_string_literal: true

module Weather
  class ImportCurrentJob < ActiveJob::Base
    queue_as :default

    def perform(obj)
      Weather::Live::BulkImport.new(obj).call
    end
  end
end
