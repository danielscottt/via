require 'pp'
require 'mongo'

module Controller
  module Blog
    include Controller
    extend self

    def get_all_posts
      @posts.find.to_a
    end

  end
end
