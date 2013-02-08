require 'restclient'
require 'digest/md5'
require 'json'

module Byline
  class Gravatar
    class GravatarException < StandardError; end

    def self.find_by_email email
      self.new(email)
    end


    def initialize args
      case
      when defined? args[ :hash ]
        @gravatar_hash = args[ :hash ]
      when defined? args[ :nick ]
        @nick = args[ :nick ]
        @gravatar_profile ||= get_gravatar_profile(@nick)
      when defined? args[ :email ]
        @gravatar_hash = Gravatar.calc_gravatar_hash(args[ :email ])
      end
    end


    def gravatar_profile
      @gravatar_profile ||= get_gravatar_profile(@gravatar_hash)
    end


    def thumbnail_url
      "http://gravatar.com/avatar/#{@gravatar_hash}.png?d=monsterid"
    end


    def photo_url size
      "http://gravatar.com/avatar/#{@gravatar_hash}.png?size=#{size}"
    end


    def about_me
      gravatar_profile && gravatar_profile['aboutMe']
    end


    def name
      gravatar_profile && gravatar_profile['name']['formatted']
    end


    def display_name
      gravatar_profile && gravatar_profile['displayName']
    end

    def gravatar_hash
      gravatar_profile && gravatar_profile['hash']
    end


    def self.calc_gravatar_hash email
      Digest::MD5.hexdigest(email)
    end


    private
    def get_gravatar_profile gravatar_hash
      url = "http://nb.gravatar.com/#{gravatar_hash}.json"
      res = RestClient.get(url)

      case res.code
      when 200 # Net::HTTPOK
        json = JSON.parse(res.body)
        json && json['entry'] && json['entry'][0] || nil
      when 404 #Net::HTTPNotFound
        nil
      else
        raise res.inspect
        raise GravatarException.new("Could not fetch profile from gravatar.com")
      end
    end
  end
end
