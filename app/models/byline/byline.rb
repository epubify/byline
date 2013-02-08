require 'active_model'
require 'simple_record'

module Byline
  class Byline < SimpleRecord::Base
    has_strings :nick, :name, :email, :gravatar_hash


    def update_gravatar_hash
      self.gravatar_hash = Gravatar.calc_gravatar_hash(email)
    end
  end
end
