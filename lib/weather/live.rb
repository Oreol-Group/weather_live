# frozen_string_literal: true

module Weather
  ##
  # The main Live class.
  class Live
    ##
    # The OpenWeatherMap's API key to use across the program
    # @return [String]
    attr_accessor :api_key

    ##
    # The default lang to use across the program
    # @return [String]
    attr_reader :default_language

    ##
    # The default country code to use across the program
    # @return [String]
    attr_reader :default_country_code

    ##
    # The default unit system to use across the program
    # @return [String]
    attr_reader :default_units

    ##
    # The default weather import mode to use across the program
    # @return [String]
    attr_accessor :default_import_mode

    ##
    # Initialize the API object
    #
    # @options[:api_key] [String] your OpenWeatherMap's API key
    #   For further information, go to https://openweathermap.org/price
    # @options[:default_language] [String] API responce language [default = 'en']
    #   Refer to https://openweathermap.org/current#multi for accepted values
    # @options[:default_country_code] [String] the country code [default = nil]
    #   (CA, ES, GB, IT, JP, RU, US etc.)
    # @options[:default_units] [String] the units system to use
    #   Accepted values:
    #   - standard (temperatures in Kelvin)
    #   - metric (temperatures in Celsius) [default]
    #   - imperial (temperatures in Fahrenheit)
    # @options[:default_import_mode] [String] the default weather import mode to use
    #   Accepted values:
    #   - on_demand (manual download) [default]
    #   - polling (automatic scheduled download)
    def initialize(options = {})
      @api_key = options[:api_key] || options['api_key']
      ObjectSpace.each_object(Weather::Live) do |el|
        raise "The API key #{@api_key} is already in use" if el.api_key == @api_key
      end

      @default_language = options[:default_language] || options['default_language'] || 'en'
      @default_country_code = options[:default_country_code] || options['default_country_code']
      @default_units = options[:default_units] || options['default_units'] || 'metric'
      @default_import_mode = options[:default_import_mode] || options['default_import_mode'] || 'on_demand'
    end

    ##
    # Get current weather at a specific location.
    #
    # @args with q [String] or id [Integer] or zip [String] for the location
    #   Can be one of this type https://openweathermap.org/current#builtin:
    #   - q [String]: search by city name
    #   (expected) - id [Integer]: search by city ID (refer to http://bulk.openweathermap.org/sample/city.list.json.gz)
    #   (expected) - zip [String]: search by zip code, for USA as a default (format : {zip code},{country code})
    # @return requested data in JSON format
    def current(**args)
      fetch_current.execute(**args)
    end

    ##
    # Insert the cities into the cached list.
    def add_cities(*list)
      Weather::Live::Cache.append_city_list(list)
    end

    ##
    # Import weather for cities from a cached list
    def bulk_import
      Weather::ImportCurrentJob.perform_later(
        {
          api_key: @api_key,
          default_language: @default_language,
          default_country_code: @default_country_code,
          default_units: @default_units,
          default_import_mode: @default_import_mode
        }
      )
    end

    ##
    # Clear the cache.
    def clear_cache
      Weather::Live::Cache.remove
    rescue NoMethodError
      nil
    end

    private

    def fetch_current
      @fetch_current ||= Weather::Live::Current.new self
    end
  end
end
