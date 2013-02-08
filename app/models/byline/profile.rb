

module Byline
  class Profile
    def initialize args
      case
      when args.include?(:hash)
        @gravatar_hash = args[ :hash ]
      when args.include?(:nick)
        @nick = args [ :nick ]
        @simple_db ||= Byline.find_by_nick(@nick)
        @gravatar_hash = simple_db.gravatar_hash
      when args.include?(:email)
        @email = args[ :email ]
        @gravatar_hash = Gravatar.calc_gravatar_hash(args[:email])
      end
    end


    def id
      @id ||= simple_db.id
    end

    def nick
      @nick ||= simple_db.nick
    end


    def name
      @name ||= simple_db.name
    end


    def email
      @email ||= simple_db.email
    end


    def gravatar_hash
      @gravatar_hash
    end


    def bio
      gravatar.about_me
    end


    def thumbnail_url
      gravatar.thumbnail_url
    end


    def photo_url size
      gravatar.photo_url(size)
    end


    private
    def gravatar
      @gravatar ||= Gravatar.new(gravatar_hash)
    end

    def simple_db
      unless @has_loaded_simple_db
        @has_loaded_simple_db = true
        @simple_db = Byline.find_by_gravatar_hash(gravatar_hash)
      end
      @simple_db
    end
  end
end
