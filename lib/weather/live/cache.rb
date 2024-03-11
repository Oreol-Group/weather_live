# frozen_string_literal: true

module Weather
  class Live
    class Cache
      class << self
        def counter
          @counter ||= Kredis.counter 'weather_counter', expires_in: 10.minutes
        end

        def w_city
          @w_city ||= Kredis.hash 'weather_cities', default: '{}'
        end

        def city_list
          @city_list ||= Kredis.list 'weather_city_list'
        end

        def fetch_cache(key)
          if counter.value.zero?
            w_city.del
            return nil
          end

          return nil if w_city[key].nil?

          res = begin
            JSON.parse(w_city[key], symbolize_names: true)
          rescue
            nil
          end
          return nil if res.nil? || res.empty?

          res
        end

        def save_to_cache(key, data)
          w_city[key] = data.to_json
          counter.increment by: 1
        end

        def fetch_city_list
          city_list.elements || []
        end

        def append_city_list
          city_list.append c []
        end

        def remove
          w_city.del
          city_list.del
        end
      end
    end
  end
end
