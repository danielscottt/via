require 'yaml'
require 'mongo'

logger = Logger.new(STDOUT)
require "pathname"

root_path = Pathname(__FILE__).expand_path.parent.parent.to_s
$LOAD_PATH.unshift(root_path)
$LOAD_PATH.unshift(File.join(root_path, "controllers"))

logger.info('Initalizing db')
CONFIG = YAML.load_file(File.join(root_path, "settings/config.yaml"))
conn = CONFIG[:mongo_server] ? Mongo::MongoClient.new(CONFIG[:mongo_server][:address], CONFIG[:mongo_server][:port]) : Mongo::MongoClient.new
db = conn[CONFIG[:db_name]]

logger.info("initializing controllers")
require "blog_controller"
Controller::Blog.init(db)

require 'via'
