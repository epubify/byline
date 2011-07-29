require 'active_model'
require 'simple_record'

module BylineEngine
  class Engine < Rails::Engine

    initializer 'simpledb connection' do |app|
      SimpleRecord.establish_connection(ENV['SIMPLEDB_KEY_ID'], ENV['SIMPLEDB_KEY'], :connection_mode => :per_thread, :server => ENV['SIMPLEDB_SERVER'])
    end

  end
end

