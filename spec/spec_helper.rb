# encoding: utf-8
unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
end

require 'rubygems'
require 'rspec'
require 'oauth'
require 'quickbooks-ruby'
require 'json'
require 'pry'
require 'webmock/rspec'
require 'rspec/its'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.color = true
end

I18n.enforce_available_locales = false
