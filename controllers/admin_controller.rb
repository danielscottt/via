require 'time'
require 'models/post'
require 'bcrypt'
require 'util'

module Controller
  module Admin
    extend self

    attr_reader :posts, :users

    def init(db)
      @posts = db['posts']
      @users = db['users']
    end

    def login(details)
      user = users.find_one({'user' => details['user']})
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
      if details[:published] == 'on'
          details[:pubslished] == true
      else
          details[:pubslished] == false
      end
      details['timestamp'] = Time.now
      Model::Post.new(details, posts).save
    end

    def delete_post(params)
      post_hash = posts.find_one({'id' => params[:id]})
      post = Model::Post.new(post_hash, posts)
      post.delete
    end

    def add_user(params)
    end

  end
end
