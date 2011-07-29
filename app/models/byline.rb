require 'active_model'
require 'simple_record'

class Byline < SimpleRecord::Base
  has_strings :nick, :name, :email


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
    @gravatar ||= Gravatar.new(email)
  end
end
