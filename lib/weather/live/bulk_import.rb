# frozen_string_literal: true

module Weather
  module Live
    class BulkImport
      def initialize(obj)
        @obj = Weather::API.new(
          api_key: obj.api_key,
          default_language: obj.default_language,
          default_units: obj.default_units,
          default_country_code: obj.default_country_code
        )
      end

      def call
        Weather::Live::Cache.fetch_city_list.each do |name|
          @obj.current({ q: name })
        end
      end
    end
  end
end
