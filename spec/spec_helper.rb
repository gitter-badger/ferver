require 'rubygems'
require 'spork'
require 'coveralls'
require 'codeclimate-test-reporter'

# force the environment to 'test'
ENV['RACK_ENV'] = 'test'

CodeClimate::TestReporter.start
Coveralls.wear!

Spork.prefork do
  require File.join(File.dirname(__FILE__), '..', '/lib/', 'ferver')
  require 'ferver'

  require 'rubygems'
  require 'sinatra'
  require 'rspec'
  require 'rack/test'
  require 'rspec-html-matchers'

  # test environment stuff
  set :environment, :test
  set :run, false
  set :raise_errors, true
  set :logging, false

  EMPTY_FILE_LIST = []

  RSpec.configure do |config|
    config.include Rack::Test::Methods
  end

  def app
    @app ||= Ferver::App
  end
end

Spork.each_run do
end
