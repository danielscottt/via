require 'logger'
require File.join(File.dirname(__FILE__), 'settings/app')


set :root, File.dirname(__FILE__)
set :run, false
enable :sessions
set :session_secret, "b9565c42e826c1c5703b11f5dbcb7a37"

require 'logger'
class ::Logger; alias_method :write, :<<; end
logger  = ::Logger.new(CONFIG[:log_path], 'weekly')
use Rack::CommonLogger, logger


run Sinatra::Application
