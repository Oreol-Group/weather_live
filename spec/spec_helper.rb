# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

lib = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faker'
require 'webmock/rspec'
require 'active_job'
require 'weather'
require 'Kredis'

WebMock.allow_net_connect!(net_http_connect_on_start: true)

RSpec.configure do |config|
  # some (optional) config here

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end
end

require 'simplecov'

SimpleCov.start
