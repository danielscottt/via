module Model
  class Post

    attr_reader :title, :body, :tags, :timestamp, :details, :cursor, :published, :id

    def initialize(details, db = nil)
      @details   = details
      @id        = details['id']
      @title     = details['title']
      @body      = details['body']
      @tags      = details['tags']
      @timestamp = details['timestamp']
      @published = details['published']
      @cursor    = db if db
    end

    def month
      timestamp.month
    end

    def year
      timestamp.year
    end

    def permalink
      "#{year}/#{month}/#{slug}"
    end

    def slug
      title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end
    
    def is_published?
      if published == 'on'
        true
      else
        false
      end 
    end

    def save
      details['permalink'] = permalink
      details['tags']      = @details['tags'].split(', ')
      details['id']      ||= SecureRandom.uuid
      cursor.update({'id' => @details['id']}, {'$set' => @details}, :upsert => true)
    end

    def delete
      cursor.remove({'id' => id})
    end

  end
end
