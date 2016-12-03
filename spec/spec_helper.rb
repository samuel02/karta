# frozen_string_literal: true
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'rspec'
require 'byebug'

require 'karta'

Dir['spec/support/**/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.after do
    Karta.instance_variables.each do |ivar|
      Karta.instance_variable_set(ivar, nil)
    end
  end
end
