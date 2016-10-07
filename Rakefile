require "rubygems"
require "bundler"
require "bundler/gem_tasks"

Bundler.setup

require "rake"
require "rspec"
require "rspec/core/rake_task"

$:.unshift File.expand_path("../lib", __FILE__)
require "quickbooks-ruby"

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end


desc "Open an irb (or pry) session preloaded with Quickbooks"
task :console do
  begin
    require 'pry'
    sh %{pry -I lib -r quickbooks-ruby.rb}
  rescue LoadError => _
    sh 'irb -rubygems -I lib -r quickbooks.rb'
  end
end
