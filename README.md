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
# config/initializers/open-weather-api.rb

Weather.configure do |config|
  # API key
  config.api_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

  # Optionals
  config.default_language = 'ru'     # 'en' by default
  config.default_country_code = 'RU' # nil by default (ISO 3166-3 alfa2)
  config.default_units = 'metric'    # 'metric' by default
                                     # - metric (temperatures in Celsius)
                                     # - imperial (temperatures in Fahrenheit)
                                     # - standard (Temperature in Kelvin)
end
```

Outside of the configuration file, you can access the api object as follows:

```ruby
Rails.configuration.weather_live
```

### Generic

```ruby
weather_live = Weather::API.new api_key: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", default_language: 'ru', default_units: 'metric', default_country_code: 'RU'
# ...
```

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
