begin
  require 'simplecov'
  SimpleCov.start
  if ENV['CI']=='true'
    require 'codecov'
    SimpleCov.formatter = SimpleCov::Formatter::Codecov
  end
rescue LoadError
end

require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: File.dirname(__FILE__) + "/tmp/test.sqlite3")

puts "Using ActiveRecord #{ActiveRecord::VERSION::STRING}"

load File.dirname(__FILE__) + '/support/schema.rb'

require File.dirname(__FILE__) + '/../lib/attr_digest.rb'

require 'support/models'

require 'factory_girl'
FactoryGirl.find_definitions

require "rspec/expectations"

RSpec.configure do |config|
  config.before(:each) do
    ModelWithAttrDigest.delete_all
  end

  config.order = 'random'
end
