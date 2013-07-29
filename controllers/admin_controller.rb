require 'time'
require 'models/post'
require 'bcrypt'
require 'util'

module Controller
  module Admin
    extend self

    def init(db)
      @posts = db['posts']
      @users = db['users']
    end

    def login(details)
      user = @users.find_one({'user' => details['user']})
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
      markdown = Redcarpet::Markdown.new(HTMLWithPygments, :fenced_code_blocks => true)
      details['body']      = markdown.render(details['body']) 
      details['timestamp'] = Time.now
      Model::Post.new(details, @posts).save
    end

  end
end
