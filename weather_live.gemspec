# frozen_string_literal: true

require './lib/weather/version'

Gem::Specification.new do |spec|
  spec.name                  = 'weather_live'
  spec.version               = Weather::VERSION
  spec.licenses              = ['MIT']
  spec.summary               =
    'Ruby SDK for providing current weather data using the OpenWeatherMap API.'
  spec.description           = <<~DES
    This gem delivers current global weather data
    from the web provider in on-demand and polling mode.
  DES
  spec.authors               = ['Nikolai Bocharov']
  spec.email                 = ['it.architect@yahoo.com']
  spec.files                 = `git ls-files -z`.split("\x0")
  spec.require_paths         = ['lib']
  spec.extra_rdoc_files      = ['README.md', 'LICENSE.md']
  spec.homepage              = 'https://rubygems.org/gems/weather_live'
  spec.metadata              = {
    'source_code_uri' => 'https://github.com/oreol-group/weather_live',
    'changelog_uri' => 'https://github.com/oreol-group/weather_live/blob/master/CHANGELOG.md',
    'bug_tracker_uri' => 'https://github.com/weather_live/sequel-sequence/issues'
  }
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 3.0.0'

  spec.add_dependency 'activejob', '~> 7.1', '>= 7.1.3.2'
  spec.add_dependency 'clockwork', '~> 3.0', '>= 3.0.2'
  spec.add_dependency 'faraday', '~> 2.9'
  spec.add_dependency 'faraday-retry', '~> 2.2'
  spec.add_dependency 'kredis', '~> 1.7'
  spec.add_development_dependency 'bundler', '~> 2.5', '>= 2.5.6'
  spec.add_development_dependency 'faker', '~> 3.2', '>= 3.2.3'
  spec.add_development_dependency 'rake', '~> 13.2.1'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'rubocop', '~> 1.62'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.add_development_dependency 'rubocop-rspec', '>= 2.27.1', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'
  spec.add_development_dependency 'webmock', '~> 3.23'
end
