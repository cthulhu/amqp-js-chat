require "rubygems"
require 'mq'
require 'json'

AMQP.start(:host => '109.74.202.172') do
  MQ.new.queue('auto').bind('simple_chat', :key => "simple_chat" ).subscribe{ |msg|
    puts msg 
  }

  exchange = MQ::Exchange.new(MQ.new, :direct, "simple_chat" )
  #exchange = MQ::Exchange.new(MQ.new, :fanout, 'simple_chat', :key => 'simple_chat')
  EM.add_periodic_timer( 10 ){
    exchange.publish( { "value" => "Auto puts from ruby client every 10 seconds: Time is #{Time.now.to_s}" }.to_json, :key => "simple_chat" )
  }
  
end
