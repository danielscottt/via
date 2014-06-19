require 'time'
require 'models/post'
require 'models/topic'
require 'bcrypt'

module Controller
  module Blog
    extend self

    def init(db)
      @db = db
    end

    def get_topics
      @db['topics'].find.to_a.map { |t| Model::Topic.new(t['name'], @db) }
    end

    def get_all_posts
      @db['posts'].find({}, {:sort => ['timestamp', :desc]}).to_a.map { |p| Model::Post.new(p) }
    end

   def get_single_post(year, month, slug)
     permalink = "#{year}/#{month}/#{slug}"
     post_hash = @db['posts'].find_one({'permalink' => permalink})
     if post_hash
       Model::Post.new(@db['posts'].find_one(post_hash))
     else
       nil
     end
   end

    def get_posts_by_tag(tag)
      posts = []
      @db['posts'].find({'tags' => tag}).to_a.each{|p| posts << Model::Post.new(p)}
      posts
    end
    
    def compile_body(body)
      markdown = Redcarpet::Markdown.new(HTMLWithPygments, :fenced_code_blocks => true)
      markdown.render(body) 
    end

  end
end
