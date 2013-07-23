module Model
  class Post

    attr_reader :title, :body, :tags, :timestamp

    def initialize(details, db = nil)
      @title     = details['title']
      @body      = details['body']
      @tags      = details['tags']
      @timestamp = details['timestamp']
      @cursor    = db['posts'] if db
    end

    def month
      @timestamp.month
    end

    def year
      @timestamp.year
    end

    def permalink
      "#{year}/#{month}/#{slug}"
    end

    def slug
      @title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end

    def save
      details['permalink'] = permalink
      @cusror.update(details, {'$set' => details})
    end

  end
end
