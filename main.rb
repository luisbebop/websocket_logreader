require 'rubygems'
require 'eventmachine'
require 'em-websocket'

# def watch_for(file, pattern)
#   f = File.open(file,"r")
#   f.seek(0,IO::SEEK_END)
#   while true do
#     select([f])
#     line = f.gets
#     puts "Found it! #{line}"
#     # puts "Found it! #{line}" if line=~pattern
#   end
# end
# 
# watch_for("log.txt",/ERROR/)


f = File.open("log.txt","r")
f.seek(0,IO::SEEK_END)
 
EventMachine.run do
  @socket = nil
  
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen    { ws.send "Hello Client!"}
    ws.onmessage { |msg| ws.send "Pong: #{msg}" }
    ws.onclose   { puts "WebSocket closed" }
    @socket = ws
  end
  
  EM.add_periodic_timer(1) do
    select([f])
    line = f.gets
    @socket.send "#{line}" if line != nil && @socket
    # puts "Found it! #{line.size} #{line}" if line != nil
  end
  
  # EM.add_timer(3) do
  #   puts "I waited 3 seconds"
  #   EM.stop_event_loop
  # end
end

puts "All done."