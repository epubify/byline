require 'httparty'
require 'restclient'
require 'digest/md5'
require 'json'

class Gravatar
  class GravatarException < StandardError; end

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
