require "rubygems"
require 'mq'
require 'json'

AMQP.start(:host => '109.74.202.172') do
  mq_all = MQ.new
  mq_all.queue('all games topics').bind(mq_all.topic("games"), :key => "game_*" ).subscribe{ |info, msg|
    puts "All games messages by key #{info.routing_key}, message #{msg}" 
  }
  mq_1 = MQ.new
  mq_1.queue('game 1 topics').bind(mq_1.topic("games"), :key => "game_1" ).subscribe{ |msg|
    puts "Game 1 message #{msg}" 
  }
  mq_2 = MQ.new
  mq_2.queue('game 2 topics').bind(mq_2.topic("games"), :key => "game_2" ).subscribe{ |msg|
    puts "Game 2 message #{msg}" 
  }

  exchange = MQ::Exchange.new(MQ.new, :topic, "games" )
  #exchange = MQ::Exchange.new(MQ.new, :fanout, 'simple_chat', :key => 'simple_chat')
  EM.add_periodic_timer( 10 ){
    ["game_1", "game_2"].each do |game|
      exchange.publish( { "value" => "Game #{game} message" }.to_json, :key => game )
    end
  }
  
end
