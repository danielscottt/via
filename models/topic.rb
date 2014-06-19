module Model

  class Topic

    attr_reader :name

    def initialize(name, db = nil)
      @name   = name
      @cursor = db
    end

    def to_s
      @name
    end

    def save
      @cursor['topics'].update({'name' => @name}, {'$set' => {'name' => @name}}, :upsert => true)
    end

    def posts
      @cursor['posts'].find('topic' => @name).to_a.map { |p| Model::Post.new(p) }
    end

  end

end
