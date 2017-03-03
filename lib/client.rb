require 'socket'
require 'json'
def connect request
  host = 'localhost'     # The web server
  port = 2000                           # Default HTTP port
  socket = TCPSocket.open(host,port)  # Connect to server
  socket.print(request)               # Send request
  response = socket.read              # Read complete response
  # Split response at first blank line into headers and body
  headers,body = response.split("\r\n\r\n", 2)
  puts "Response:"
  print body
  print headers
end

path = "/index.html"
request = "GET #{path} HTTP/1.0\r\n\r\n"

connect(request)

path = "/thanks.html"
viking = {:viking => {:name=>"Erik the Red", :email=>"erikthered@theodinproject.com"} }
request = "POST #{path} HTTP/1.0\r\nFrom: John.Valanidas@gmail.com\r\nUser-Agent: clint.rb\r\nContent-Type: Json\r\nContent-Length #{viking.size}\r\n\r\nswaf"

connect(request)
