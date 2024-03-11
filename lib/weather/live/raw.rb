# frozen_string_literal: true

module Weather
  class Live
    class Raw
      class << self
        def serialize(body)
          description = body[:weather].first[:description]
          main = body[:weather].first[:main]
          speed = body.dig(:wind, :speed)
          sunrise = body.dig(:sys, :sunrise)
          sunset = body.dig(:sys, :speed)
          feels_like = body.dig(:main, :feels_like)
          temp = body.dig(:main, :temp)
          humidity = body.dig(:main, :humidity)
          pressure = body.dig(:main, :pressure)
          body.delete_if do |key, _value|
            key in [ :base,
                     :clouds,
                     :cod,
                     :coord,
                     :dt,
                     :id,
                     :main,
                     :sys,
                     :wind,
                     :weather ]
          end
          body[:pressure] = pressure
          body[:humidity] = humidity
          body[:wind] = { speed: speed }
          body[:weather] = { main: main, description: description }
          body[:sys] = { sunrise: sunrise, sunset: sunset }
          body[:temperature] = { feels_like: feels_like, temp: temp }
        end
      end
    end
  end
end
