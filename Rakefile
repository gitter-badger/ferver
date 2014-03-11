require "bundler/gem_tasks"
require 'rspec/core'
require 'rspec/core/rake_task'
 
task :default => :spec
 
desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec)

desc "Run ferver locally from source"
task :server do |t, args|

    require 'rubygems'
    require 'bundler'
    Bundler.setup
    require 'ferver'

    # use the last argument (first is the rake task) as the file path to serve from
    ferver_path = (ARGV.length == 2 && ARGV.last) || nil
    Ferver::App.set :ferver_path, ferver_path

    # run!
    Ferver::App.run!

end