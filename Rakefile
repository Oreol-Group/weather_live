# frozen_string_literal: true

require 'weather/live'
require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'fileutils'

RuboCop::RakeTask.new

task default: %i[test rubocop]

# Test
task :test do
  sh 'bundle exec rspec spec'
end
