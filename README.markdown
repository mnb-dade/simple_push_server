# Simple Push Server
Using Redis, Sinatra, and Server-Sent Events

## Getting it up and running

First, make sure Redis is running.

Start the server then browse to http://localhost:4567 

    $ ruby server.rb

In another terminal window, publish messages to the "stream" channel

    redis-cli
    > publish stream "Hello World!"
