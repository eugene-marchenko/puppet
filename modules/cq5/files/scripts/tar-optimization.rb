#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'
require 'curb'
require 'logger'
require 'nokogiri'
require 'pp'

@options = {
  :host => 'localhost',
  :port => 4502,
  :user => 'admin',
  :pass => 'admin',
  :sleep => '1.0',
  :ws => 'crx.default',
  :loglevel => Logger::INFO,
}

opts = OptionParser.new do |opts|
  opts.banner = "Usage: SCRIPT [options]"
  opts.on('-h', '--host HOSTNAME',
          'The server hostname') do |opt|
    @options[:host] = opt
  end
  opts.on('-p', '--port PORT', Integer,
          'The server port') do |opt|
    @options[:port] = opt
  end
  opts.on('-u', '--user USERNAME',
          'The username to authenticate with') do |opt|
    @options[:user] = opt
  end
  opts.on('--pass PASSWORD',
          'The password to authenticat with') do |opt|
    @options[:pass] = opt
  end
  opts.on('-w', '--workspace WORKSPACE',
          'The workspace to login to') do |opt|
    @options[:ws] = opt
  end
  opts.on('-s', '--sleep MS', Float,
          'Delay after optimizing one transaction (in ms)') do |opt|
    @options[:sleep] = opt
  end
  opts.on('-a', '--action ACTION',
          'The action to perform, i.e. run, stop') do |opt|
    if [ 'start', 'stop' ].include?(opt.downcase)
      @options[:action] = opt.downcase
    else
      raise ArgumentError, "Invalid action: #{opt}"
    end
  end
  opts.on('--ssl',
          'Specify if the host is SSL enabled') do |opt|
    @options[:ssl] = opt
  end
  opts.on('-l', '--loglevel LOGLEVEL',
          'Specify one of the following loglevels: FATAL,ERROR,WARN,INFO,DEBUG') do |opt|
    if [ 'fatal', 'error', 'warn', 'info', 'debug' ].include?(opt.downcase)
      levels = {
        'fatal' => Logger::FATAL,
        'error' => Logger::ERROR,
        'warn'  => Logger::WARN,
        'info'  => Logger::INFO,
        'debug' => Logger::DEBUG,
      }
      @options[:loglevel] = levels[opt.downcase]
    else
      raise ArgumentError, "Invalid loglevel: #{opt}"
    end
  end
  opts.on('--dry-run',
          "Attempt to login but don't run the scan") do |opt|
    @options[:dryrun] = opt
  end
  opts.on('--help', 'help',
          'Print the help message') do |opt|
    puts opts
    exit
  end
end

opts.parse!

def base_path
  if @options[:ssl]
    return "https://#{@options[:host]}:#{@options[:port]}"
  else
    return "http://#{@options[:host]}:#{@options[:port]}"
  end
end

def auth_path
  user  = "UserId=#{@options[:user]}"
  pass  = "Password=#{@options[:pass]}"
  ws    = "Workspace=#{@options[:ws]}"
  return "crx/index.jsp?#{user}&#{pass}&#{ws}"
end

def taropt_path(action)
  path = "crx/config/tarpm_optimization.jsp?sleep=#{@options[:sleep]}"
  path = path + "&action=run"
  path = path + "&optimizeAction=#{action}"
  return path
end

def refresh_path
  return "crx/config/tarpm_optimization.jsp"
end

def curl(path, sess=nil, body_contains=[])
  obj = Curl::Easy.new(path)

  cookies = ""
  # Set on header handler to keep session cookies
  buffer = ""
  obj.on_header do |header|
    cookies = header.split(/:/)[-1].strip if header =~ /Set-Cookie/
    header.size
  end

  # Set on body handler to match specific response body text
  buffer = ""
  obj.on_body do |body|
    if body_contains.respond_to?(:each)
      body_contains.each do |b|
        if body =~ /#{b[0]}/
          body = check_body(body,b[0],b[1])
          @log.debug(body)
          return true
        end
      end
    end
    body.size
  end

  # Run the Curl action
  if not sess
    obj.perform
    # Save any cookie state
    obj.cookies = cookies
  else
    obj.cookies = sess
    obj.perform
  end

  return obj
end

def check_body(body,text,element)
  body = Nokogiri::HTML(body)
  body = body.xpath("//#{element}[contains(text(), '#{text}')]")
  if body
    if body.children[0]
      return body.children[0].content.strip
    end
  end
  
  return false
end


def run
  # Construct our options hash
  basepath = base_path
  authpath = "#{basepath}/#{auth_path}"
  taroptpath = "#{basepath}/#{taropt_path(@options[:action])}"
  refreshpath = "#{basepath}/#{refresh_path}"

  # Initialize Logger
  @log = Logger.new(STDOUT)
  @log.level = @options[:loglevel]

  # Set our start time
  start_time = Time.now
  
  # Authenticate and get a session cookie
  c = curl(authpath)
  sess = c.cookies

  unless c.response_code == 200
    raise Curl::Err::AccessDeniedError, 'Invalid username or password'
  end
  
  # Run the Tar Optimization
  if @options[:dryrun]
    @log.info("DRYRUN - Would run the following #{taroptpath}")
  else
    if @options[:action] == 'start'
      # First check if it's already running
      res = curl(refreshpath,sess,[[ 'Optimization is running since', 'b']])
      raise Exception, "TarPM Optimization already in progress, aborting..." if res == true
      # Next execute the optimization
      curl(taroptpath,sess)
      sleep(1)
      while curl(refreshpath,sess,[['Optimization is running since', 'b']]) == true do
        sleep(30)
      end
      @log.info("Completed Tar Optimization in #{Time.now - start_time}s")
    else
      # Check that it's running
      if curl(refreshpath,sess,[['Optimization is running since', 'b']]) == true
        # Stop it
        res = curl(taroptpath,sess,[['Optimization is not currently running', 'td']])
        raise Exception, "Failed in stopping TarPM Optimization" if res != true
        @log.info("Stopped TarPM Optimization at #{Time.now}s")
      else
        @log.info("TarPM Optimization is already stopped")
      end
    end

  end
end

# Run it!
run()
