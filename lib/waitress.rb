require 'sinatra/base'
require 'sinatra/redis'
require 'haml'

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
    content_type 'text/html', :charset => 'utf-8'
    haml :list, :locals => {:orders => redis.keys}
  end
  
  get '/usage' do
    content_type 'text/plain', :charset => 'utf-8'
    erb :usage
  end
  
  get '/:mac_address' do
    content_type 'application/json'
    find_order( params[:mac_address] )
  end

  post '/' do
    content_type 'application/json'
    if params[:mac_address] and params[:node]
      take_order params[:mac_address], params[:node]
      erb "{\"Status\": \"Order up for #{params[:mac_address]}.\"}"
    else
      halt 500, "{\"Status\": \"Malformed order. I need a mac_address and a node JSON to take your order.\"}"
    end
  end
  
  def find_order( mac_address )
    order = redis.get( mac_address )
    if order
      redis.del( mac_address )
      return order
    else
      halt 404, "{\"Status\": \"Are you sure you have an order up?  I can\'t seem to find it.\"}"
    end
  end
  
  def take_order( mac_address, node )
    redis.set(mac_address, node)
  end
end