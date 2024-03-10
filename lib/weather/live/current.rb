# frozen_string_literal: true

module Weather
  module Live
    class Current < Base
      ##
      # The OpenWeatherMap's API version.

      VERSION = '2.5'

      ##
      # The OpenWeatherMap's endpoint to the current weather.

      def url
        "#{super}data/#{VERSION}/weather"
      end

      ##
      # The `q` parameters builder for OpenWeatherMap's endpoint
      # to the current weather https://openweathermap.org/current#builtin
      # Input parameter is `city_name`

      def build_params(parameters = {})
        super.merge({ units: @api_obj.default_units,
                      lang: @api_obj.default_language })
             .merge(fetch_city_name(parameters))
      end

      private

      def extract_hash_key(**data)
        @hash_key = data['q']
      end

      def get(path, params)
        _status, _headers, body = super
        responce = Weather::Live::Raw.serialize(body)
        Weather::Live::Cache.save_to_cache(@hash_key, JSON.pretty_generate(responce))
        responce
      end

      def error_message(body)
        case response_content_type
        when :json
          body[:message]
        when :html
          body
        else
          ''
        end
      end

      def fetch_city_name(params)
        city = take_city(params)
        build_city_hash(city.split(',')) || {}
      end

      def take_city(params)
        if params.key?(:city_name)
          params[:city_name]
        elsif params.key?('city_name')
          params['city_name']
        elsif params.key?('q')
          params['q']
        elsif params.key?(:q)
          params[:q]
        else
          ''
        end
      end

      def build_city_hash(parametrized_city_name)
        if parametrized_city_name.size > 1
          parametrized_city_name.join(',')
        elsif parametrized_city_name.size == 1
          if @api_obj.default_country_code
            { q: "#{parametrized_city_name[0]},#{@api_obj.default_country_code}" }
          else
            { q: parametrized_city_name[0] }
          end
        end
      end
    end
  end
end
