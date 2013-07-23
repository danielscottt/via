require 'mongo'
require 'controller/blog_controller'

module Controller
  extend self

    def init(config)
      @logger = Logger.new(STDOUT)
      unless config[:mongo_server]
        @conn = Mongo::MongoClient.new
      else
        @conn = Mongo::MongoClient.new(config[:mongo_server][:address], config[:mongo_server][:mongo_port])
      end
      @db    = @conn[config[:db_name]]
      @posts = @db['posts']
    end

end
