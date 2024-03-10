# frozen_string_literal: true

module Weather
  module Live
    class Cache
      class << self
        def w_city
          @w_city ||= Kredis.hash 'weather_cities'
        end

        def city_list
          @city_list ||= Kredis.list 'weather_city_list'
        end

        def fetch_cache(key)
          JSON.parse(w_city[key], symbolize_names: true)
        end

        def save_to_cache(key, data)
          w_city[key] = data
        end

        def fetch_city_list
          city_list.elements || []
        end

        def append_city_list
          city_list.append || []
        end

        def remove
          w_city.remove
          city_list.clear
          city_list.remove
        end
      end
    end
  end
end
