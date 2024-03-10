# frozen_string_literal: true

module Weather
  def self.configure(&block)
    raise ArgumentError, 'No block was given.' unless block

    api = Rails.configuration.weather_live = Weather::Live.new
    block.call(api)
    api
  end
end
