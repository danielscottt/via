require 'yaml'
require 'mongo'

require 'pathname'
root_path = Pathname(__FILE__).expand_path.parent.parent.to_s
$LOAD_PATH.unshift(root_path)
$LOAD_PATH.unshift(File.join(root_path, 'controllers'))

CONFIG = YAML.load_file(File.join(root_path, 'settings/config.yaml'))
conn   = CONFIG[:mongo] ? Mongo::MongoClient.new(CONFIG[:mongo][:address], CONFIG[:mongo][:port]) : Mongo::MongoClient.new
db     = conn[CONFIG[:mongo][:db_name]]

require 'logger'
LOGGER = Logger.new(CONFIG[:log_path], 'weekly')

require 'blog_controller'
require 'admin_controller'
Controller::Admin.init(db)
Controller::Blog.init(db)

require 'via'
