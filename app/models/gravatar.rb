require 'httparty'
require 'digest/md5'


class Gravatar
  class GravatarException < StandardError; end

  include HTTParty

  def self.find_by_email email
    self.new(email)
  end


  def initialize email
    digest = Digest::MD5.hexdigest(email)
    @gravatar_hash = digest
  end


  def gravatar_profile
    @gravatar_profile ||= get_gravatar_profile(@gravatar_hash)
  end


  def thumbnail_url
    gravatar_profile && gravatar_profile['thumbnailUrl']
  end


  def photo_url size
    gravatar_profile && "#{gravatar_profile['thumbnailUrl']}?size=#{size}"
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


private
  def get_gravatar_profile gravatar_hash
    res = self.class.get "http://gravatar.com/#{gravatar_hash}.json"
    case res.response
    when Net::HTTPOK
      res.parsed_response["entry"][0]
    when Net::HTTPNotFound
      nil
    else
      raise res.inspect
      raise GravatarException.new("Could not fetch profile from gravatar.com")
    end
  end
end
