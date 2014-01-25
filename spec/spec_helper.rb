require 'rubygems'
require 'spork'

ENV['RACK_ENV'] = 'test'  # force the environment to 'test'

Spork.prefork do
  require File.join(File.dirname(__FILE__), '..', '/src/', 'ferver')

  require 'rubygems'
  require 'sinatra'
  require 'rspec'
  require 'rack/test'
  require 'webrat'
  require 'coveralls'

  # test environment stuff
  set :environment, :testf
  set :run, false
  set :raise_errors, true
  set :logging, false

  Coveralls.wear!

  RSpec.configure do |conf|
    conf.include Rack::Test::Methods
    conf.mock_framework = :mocha
  end

  def app
    @app ||= Ferver
  end
end

Spork.each_run do
end