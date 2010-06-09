require 'sinatra/base'
require 'sinatra/redis'
require 'ruby-debug'

class Waitress < Sinatra::Base
  def self.redis
    return @redis if @redis
    @redis = Redis.new(:host => '127.0.0.1', :port => 6379, :thread_safe => true)
  end
  
  def self.redis=(redis)
    @redis = redis
  end
  
  def redis
    Waitress.redis
  end
  
  get '/' do
    content_type 'text/plain', :charset => 'utf-8'
    erb :usage
  end
  
  # GET /B2-E7-D1-A7-61-9D
  get '/:mac_address' do
    content_type 'application/json'
    find_mac_address( params[:mac_address] )
  end

  post '/:mac_address' do
    if params[:node]
      create_mac_pairing params[:mac_address], params[:node]
    else
      halt 500, 'Malformated order.'
    end
  end
  
  def find_mac_address(mac_address)
    redis.get( mac_address )
  end
end