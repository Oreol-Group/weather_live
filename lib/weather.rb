# frozen_string_literal: true

require 'open-weather-api/version'

require 'weather/live'

# Dependencies
require 'faraday'
require 'faraday/retry'
require 'json'

# HTTP-client
require 'weather/connection'

# live
require 'weather/live/base'
require 'weather/live/current'

# Configuration
require 'weather/config'

# Main file
require 'weather/api'

module Weather
  # Base exception for the OpenWeatherMap library
  class Exception < StandardError
    def initialize(status, message)
      message = "Status: #{status}; Error: #{message}"
      super(message)
    end
  end

  ##
  # Exceptions that can be thrown by the library
  module Exceptions
    ##
    # Exception to handle unknown location
    # API calls return an error 404
    class UnknownLocation < Weather::Exception; end
    ##
    # Exception to tell that the API key isn't authorized
    # API calls return an error 401
    class Unauthorized < Weather::Exception; end
    ##
    # Exception to handle rate limits.
    # API calls return an error 429
    # If you have a Free plan of Professional subscriptions and
    # make more than 60 API calls per minute
    # (surpassing the limit of your subscription).
    # https://openweathermap.org/faq
    class ApiLimitError < Weather::Exception; end
    ##
    # Exception to handle data error
    class DataError < Weather::Exception; end
  end
end
