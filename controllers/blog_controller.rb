require 'time'
require 'models/post'

module Controller
  module Blog
    extend self

    def init(db)
      @posts = db['posts']
      @users = db['users']
    end

    def get_all_posts
      posts = []
      @posts.find.to_a.each{|p| posts << Model::Post.new(p)}
    end

   def get_single_post(year, month, slug)
     permalink = "#{year}/#{month}/#{slug}"
     post = Model::Post.new(@posts.find_one({'permalink' => permalink}))
   end

   def login(details)
     user = @users.find_one({'user' => details['user']})
     if user['password'] == details['password']
       result = 'success'
     else
       result = {
         'entered' => details['password'],
         'user'    => details['user'],
       }
     end
   end
     
  end
end
