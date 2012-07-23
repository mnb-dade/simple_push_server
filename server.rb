require 'haml'
require 'json'
require 'redis'
require 'sinatra'

redis = Redis.new(:timeout => 0)
connections = []
stream_started = false

get '/' do
  haml :index
end

get '/stream', provides: 'text/event-stream' do
  stream :keep_open do |out|
    connections << out
    
    # Set callback to remove connection from array (fired when stream closes).
    out.callback do
      connections.delete(connections)
    end

    if not stream_started

      stream_started = true
      
      # Send heartbeat to connections to keep them alive
      EM.add_periodic_timer(10) do
        if connections.length
          puts "Sending heartbeat to #{connections.length} connections"
          connections.each { |out| out << ": heartbeat\n\n" }
        end
      end
      
      # Subscribe to redis channel
      redis.subscribe('stream') do |on|
        on.message do |channel, msg|
          # data = JSON.parse(msg)
          connections.each { |out| out << "data: #{msg}\n\n" }
        end
      end

    end

  end
end
