require 'socket'
require 'json'
class Server

  attr_accessor :method, :path, :version
  @perams = {}

  def initialize port
    @server = TCPServer.open(port)
    @paths = []
    buildpaths
  end

  def start
    loop do
      @client = @server.accept
      request = @client.gets
      parse(request)
      puts
      interpert
      log
      @client.close
    end
  end

  private

  def log
    puts "#{Time.new.ctime}: a client connected"
    puts "with header: #{@method} #{@path} #{@version} \n"
  end

  def parse(request)
    @header, @body = request.split("\r\n\r\n", 2)
    @method, @path, @version = @header.split(/\s/,3)
  end

  def buildpaths
    file_paths = Dir::entries("pages/")
    file_paths.each {|item| @paths.push("/" +item)}
  end

  def interpert
    if @method == "GET" && @paths.include?(@path)
      loadpage
    elsif @method == "HEAD"
    elsif @method == "POST"
      #@params = JSON.parse(@body)
    elsif @method == "DELETE"
    elsif @method == "PUT"
    elsif @mehtod == "OPTIONS"
    elsif @method == "CONNECT"
    else
      loadresponse("HTTP/1.0", 404,"Not Found", "none", 0)
    end
  end

  def loadpage
    page = IO.read("pages" + @path)
    loadresponse("HTTP/1.0",200,"OK","text/html", page.length)
    @client.puts "#{page}"
  end

  def loadresponse(version, code, phrase, content_type, content_length)
    response = ["#{version} #{code} #{phrase}",
                format_time,
                "Content-Type: " + content_type,
                "Content-Length: " + content_length.to_s
    ]
    response.each {|line| @client.puts line}
    @client.puts
  end

  def format_time
    t = Time.now.gmtime
    #Date: Fri, 31 Dec 1999 23:59:59 GMT
    "Date: #{t.strftime("%a")}, #{t.strftime("%d")} #{t.strftime("%b")} #{t.strftime("%Y")} #{t.strftime("%H")}:#{t.strftime("%M")}:#{t.strftime("%S")} GMT"
  end
end

server = Server.new(2000)
server.start
