require 'time'
require 'models/post'
require 'bcrypt'
require 'util'

module Controller
  module Admin
    extend self

    def init(db)
      @db = db
    end

    def login(details)
      user = @db['users'].find_one({'user' => details['user']})
      if user
        result = user.delete_if{|k,v| k == '_id'}
        if result['password'] == BCrypt::Engine.hash_secret(details['password'], result['salt'])
          result[:response] = 'success'
        else
          result[:response] = 'password incorrect'
        end
      else
        result = {:response => 'user not found'}
      end
      result
    end

    def add_post(details)
      if details['pub']
        details['published'] = true
      else
        details['published'] = false
      end
      details['timestamp'] = Time.now
      post = Model::Post.new(details.delete_if{|k, v| k == 'pub'}, @db)
      post.save
      Model::Topic.new(details['topic'], @db).save
      post
    end

    def delete_post(params)
      post_hash = @db['posts'].find_one({'id' => params[:id]})
      post = Model::Post.new(post_hash, posts)
      post.delete
    end

    def add_user(params)
    end

  end
end
