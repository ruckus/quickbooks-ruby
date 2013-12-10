# encoding: utf-8
unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
end

require 'rubygems'
require 'rspec'
require 'fakeweb'
require 'oauth'
require 'quickbooks-ruby'
require 'json'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.color_enabled = true
end
