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
      @posts.find({}, {:sort => ['timestamp', :desc]}).to_a.each{|p| posts << Model::Post.new(p)}
      posts
    end

   def get_single_post(year, month, slug)
     permalink = "#{year}/#{month}/#{slug}"
     post_hash = @posts.find_one({'permalink' => permalink})
     if post_hash
       post = Model::Post.new(@posts.find_one(post_hash))
     else
       nil
     end
   end

    def get_posts_by_tag(tag)
      posts = []
      @posts.find({'tags' => tag}).to_a.each{|p| posts << Model::Post.new(p)}
      posts
    end
    
    def compile_body(body)
      markdown = Redcarpet::Markdown.new(HTMLWithPygments, :fenced_code_blocks => true)
      markdown.render(body) 
    end

  end
end
