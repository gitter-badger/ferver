#!/usr/bin/env ruby
# encoding: UTF-8

###
# ferver - A simple Ruby app serving files over HTTP
# (c) 2014 Robert Murray
# @see https://github.com/rob-murray/ferver
# http-file-server may be freely distributed under the MIT license
###
require "sinatra"
require "json"
require "sinatra/base"


class Ferver < Sinatra::Base

  # Config
  set :inline_templates, true
  set :app_file, __FILE__

  # By default, serve files from current location
  DEFAULT_FILE_SERVER_DIR_PATH = './'

  # redirect to file list
  # /
  get '/' do

    redirect to('/files.html')

  end


  # list files
  # /files.html
  get '/files.html' do

    @file_count = @file_list.size
    @ferver_path = get_current_ferver_path

    erb :file_list_view
    
  end


  # list files
  # /files.json
  get '/files.json' do
    
    content_type :json
    
    @file_list.to_json
    
  end


  # download file
  # /files/:id
  get '/files/:id' do
    
    id = params[:id].to_i
    
    if id < @file_list.size

      file = get_path_for_file(get_current_ferver_path, @file_list[id])

      send_file(file, :disposition => 'attachment', :filename => File.basename(file))

    else

      status 404

    end
    
  end


  # Find all files in `Ferver` directory. 
  # Called before each response.
  #
  before do
    
    @file_list = []

    current_directory = get_current_ferver_path
    
    Dir.foreach(current_directory) do |file|

      next if file == '.' or file == '..'

      file_path = get_path_for_file(current_directory, file)

      @file_list.push(file) if File.file?(file_path)

    end

  end

  private

  # Return an absolute path to a `file_name` in the `directory`
  #
  #
  def get_path_for_file(directory, file_name)

    File.join(directory, file_name)

  end

  # Return the absolute path to the directory Ferver is serving files from.
  # This can be specified in Sinatra configuration; 
  #   i.e. `Ferver.set :ferver_path, ferver_path` or the default if nil
  #
  def get_current_ferver_path

    path = nil

    if settings.respond_to?(:ferver_path) and settings.ferver_path

      path = settings.ferver_path

    else

      path = DEFAULT_FILE_SERVER_DIR_PATH

    end

    File.expand_path(path)

  end


end

__END__
 
@@file_list_view
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Ferver File List</title>
  </head>
  <body>
    <h3>Files served:</h3>
    <ul>
      <% @file_list.each_with_index do |file_name, index| %>

        <li><a href="/files/<%= index %>"><%= file_name %></a></li>

      <% end %>

    </ul>

    <p><%= @file_count %> files served from: <%= @ferver_path %></p>

    <hr>

    <p>Served by: <a href="https://github.com/rob-murray/ferver" title="Ferver: A simple Ruby app serving files over HTTP">Ferver</a></p>

  </body>
</html>

<html>
<body>


