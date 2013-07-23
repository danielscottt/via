require 'logger'
require './settings/app'

set :root, File.dirname(__FILE__)
set :run, false

run Sinatra::Application
