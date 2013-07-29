require 'logger'
require './settings/app'


set :root, File.dirname(__FILE__)
set :run, false
enable :sessions
set :session_secret, "b9565c42e826c1c5703b11f5dbcb7a37"

run Sinatra::Application
