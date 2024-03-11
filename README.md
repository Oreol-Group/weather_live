# weather_live
Ruby SDK for providing current weather data using the OpenWeatherMap API.

With this gem you will be able to deliver current global weather data from the web provider in on-demand and polling mode.

## Installation

```bash
$ gem install weather_live
```

Or add the following line to your project's Gemfile:

```ruby
gem 'weather_live'
```

And then execute:

```bash
$ bundle install
```

## Setup the API

First of all, register on the [OpenWeatherMap](https://openweathermap.org/appid) website and [get or generate](https://home.openweathermap.org/api_keys) an API key.

After that, init the API with the `weather_live` library in your project:

### Rails

```ruby
# config/initializers/weather_live.rb

Weather.configure do |config|
  # API key
  config.api_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

  # Optionals
  config.default_language = 'ru'          # 'en' by default
  config.default_country_code = 'RU'      # nil by default (ISO 3166-3 alfa2)
  config.default_units = 'metric'         # 'metric' by default
                                          # - metric (temperatures in Celsius)
                                          # - imperial (temperatures in Fahrenheit)
                                          # - standard (Temperature in Kelvin)
  config.default_import_mode = 'polling'  # 'on_demand' (manual download) [default]
                                          # 'polling' (automatic scheduled download)
end
```

Outside of the configuration file, you can access the api object as follows:

```ruby
Rails.configuration.weather_live
```

### Generic

```ruby
weather_live = Weather::API.new(api_key: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1", default_language: 'ru', default_units: 'metric', default_country_code: 'RU')
# ...
```

To work with many API-keys form https://home.openweathermap.org/api_keys you could activate various configuration objects.

```ruby
weather_live_fatherland = Weather::API.new(api_key: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx2", default_language: 'de', default_units: 'metric', default_country_code: 'DE')
# ...
```

## Usage

This gem returns responses to API requests in Hash format:
```JSON
{
  "weather": {
    "main": "Clouds",
    "description": "scattered clouds",
  },
  "temperature": {
    "temp": 269.6,
    "feels_like": 267.57,
  },
  "visibility": 10000,
  "wind": {
    "speed": 1.38,
  },
  "datetime": 1675744800,
  "sys": {
    "sunrise": 1675751262,
    "sunset": 1675787560
  },
  "timezone": 3600,
  "name": "Zocca",
}
```

### Import mode - 'on_demand'

This lybrary allows us to get current weather by city name:
```ruby
data = weather_live.current city: 'Catania'
```

Following the API-documentation https://openweathermap.org/current#builtin we could write:
```ruby
data = weather_live.current q: 'Catania,IT'
```
or in our a more understandable form
```ruby
data = weather_live.current city: 'Clermont-Ferrand,FR'
```

### Import mode - 'polling'

Prepare list of cities for polling (no more than 60 due to the free service https://openweathermap.org/price):
```
weather_live.add_cities(['Paris', 'London', ...])
```

To activate this functionality, you will need a client for the cron service. For example, we utilize gem `clockwork`.

In the root directory of the application add `clock.rb` file with the following contents:
```ruby
# clock.rb

require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)

module Clockwork
  every(10.minutes, 'Import Weather') do
    Rails.configuration.weather_live.bulk_import
  end
end
```

After this activation, you will be able to read the weather status from the cache with zero response delay.

## Additional functionality

To minimize requests to the `OpenWeatherMap` server we use Redis for temporary caching. The data downloaded once is stored in the cache for 10 minutes. Therefore, multiple requests per unit of time will not cause rate limits on web server.

If necessary, you can force the cache to be cleared:
```ruby
weather_live.clear_cache
```

## Maintainer

- [Nikolai Bocharov](https://github.com/oreol-group)

## Contributors

- https://github.com/oreol-group/weather_live/contributors

## Contributing

For more details about how to contribute, please read
https://github.com/oreol-group/weather_live/blob/master/CONTRIBUTING.md.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT). A copy of the license can be found at https://github.com/oreol-group/weather_live/blob/master/LICENSE.md.

## Code of Conduct

Everyone interacting in the `weather_live` project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/oreol-group/weather_live/blob/master/CODE_OF_CONDUCT.md).
