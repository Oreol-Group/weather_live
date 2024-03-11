# frozen_string_literal: true

require 'spec_helper'

describe Weather::Live do
  let!(:api) do
    Weather::Live.new(
      {
        api_key: Faker::Number.number(digits: 32),
        default_language: 'fr',
        default_country_code: 'FR'
      }
    )
  end

  context 'when fetching current weather' do
    before do
      api.clear_cache
    end
    it 'should retrieve data by city name' do
      expect(api.current(city: 'Clermont-Ferrand')[:name]).to eq('Arrondissement de Clermont-Ferrand')
    end
  end
end
