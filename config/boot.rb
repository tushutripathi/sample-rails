ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

if ENV["RAILS_ENV"] == "development" or ENV["RAILS_ENV"] == "test"
  # Don't require in production/staging, it may cause some issues with file
  # permissions in saving logs in the docker.
  require "bootsnap/setup" # Speed up boot time by caching expensive operations.
end

