require 'time'
require 'models/post'
require 'bcrypt'

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
      posts
    end

   def get_single_post(year, month, slug)
     permalink = "#{year}/#{month}/#{slug}"
     post = Model::Post.new(@posts.find_one({'permalink' => permalink}))
   end

    def get_posts_by_tag(tag)
      posts = []
      @posts.find({'tags' => tag}).to_a.each{|p| posts << Model::Post.new(p)}
      posts
    end

  end
end
