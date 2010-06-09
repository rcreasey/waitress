require File.join(File.dirname(__FILE__), '..', '..', 'lib/waitress.rb')

require 'capybara'
require 'capybara/cucumber'
require 'spec'

Waitress.set(:environment, :test)
Waitress.set(:redis, Redis.new(:host => '127.0.0.1', :port => 6379, :thread_safe => true))

World do
  Capybara.app = Waitress
  include Capybara
  include Spec::Expectations
  include Spec::Matchers
end