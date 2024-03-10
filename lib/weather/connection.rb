# frozen_string_literal: true

module Weather
  class Connection
    RETRY_OPTIONS = {
      max: 3,                     # Retry a failed request up to 3 times
      interval: 2,                # First retry after 2s
      backoff_factor: 2,          # Double the delay for each subsequent retry
      retry_statuses: [500, 502, 503, 504]
      # Retry only when we get a 500, 502, 503 or 504 response
    }.freeze

    def self.start
      @start ||= Faraday.new do |config|
        config.request :retry, RETRY_OPTIONS
        config.adapter Faraday.default_adapter
      end
    end
  end
end
