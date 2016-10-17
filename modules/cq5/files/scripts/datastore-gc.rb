#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'
require 'curb'
require 'logger'
require 'pp'

@options = {
  :host => 'localhost',
  :port => 4502,
  :user => 'admin',
  :pass => 'admin',
  :ws   => 'crx.default',
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
  opts.on('-d', '--delete',
          'Delete unused items automatically') do |opt|
    @options[:delete] = opt
  end
  opts.on('-m', '--memgc',
          'Perform a memory garbage collection') do |opt|
    @options[:memgc] = opt
  end
  opts.on('-s', '--sleep MS', Integer,
          'The time (in ms) to sleep between gc cycles') do |opt|
    @options[:sleep] = opt
  end
  opts.on('--ssl',
          'Specify if the host is SSL enabled') do |opt|
    @options[:ssl] = opt
  end
  opts.on('-l', '--loglevel LOGLEVEL',
          'Specify one of the following loglevels: FATAL,ERROR,WARN,INFO,DEBUG') do |opt|
    if [ 'fatal', 'error', 'warn', 'info', 'debug' ].include? opt.downcase
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

def construct_base_path
  if @options[:ssl]
    return "https://#{@options[:host]}:#{@options[:port]}"
  else
    return "http://#{@options[:host]}:#{@options[:port]}"
  end
end

def construct_auth_path
  user  = "UserId=#{@options[:user]}"
  pass  = "Password=#{@options[:pass]}"
  ws    = "Workspace=#{@options[:ws]}"
  return "crx/index.jsp?#{user}&#{pass}&#{ws}"
end

def construct_gc_path
  path = "crx/config/datastore_gc.jsp?action=run"
  path = path + "&memGc=checked" unless @options[:memgc].nil?
  path = path + "&sleep=#{@options[:sleep]}" unless @options[:sleep].nil?
  path = path + "&delete=checked" unless @options[:delete].nil?
  return path
end

def curl(path, obj=nil, body_filter=[])
  if obj.class == Curl::Easy
    obj.url = path
  else
    obj = Curl::Easy.new(path)
  end

  cookies = ""
  # Set on header handler to keep session cookies
  buffer = ""
  obj.on_header do |header|
    cookies = header.split(/:/)[-1].strip if header =~ /Set-Cookie/
    header.size
  end

  # Set on body handler to print specific response body text
  buffer = ""
  obj.on_body do |body|
    if body_filter.respond_to?(:each)
      body_filter.each do |b|
        if body =~ /#{b}/
          # Regex magic to strip out html tags
          @log.debug(body.gsub(/<[a-zA-Z\/][^>]*>/, '\1'))
        end
      end
    end
    body.size
  end

  # Run the Curl action
  obj.perform
  # Save any cookie state
  obj.cookies = cookies

  return obj
end


def run
  # Construct our options hash
  @options[:basepath] = construct_base_path
  @options[:authpath] = "#{@options[:basepath]}/#{construct_auth_path}"
  @options[:gcpath]   = "#{@options[:basepath]}/#{construct_gc_path}"

  # Initialize Logger
  @log = Logger.new(STDOUT)
  @log.level = @options[:loglevel]

  # Authenticate and get a session cookie
  c = curl(@options[:authpath])

  unless c.response_code == 200
    raise Curl::Err::AccessDeniedError, 'Invalid username or password'
  end
  
  # Run the GC Scan
  if @options[:dryrun]
    @log.info("DRYRUN - Would run the following #{@options[:gcpath]}")
  else
    c = curl(@options[:gcpath],c,['Scanning','scan completed'])
    @log.info("Completed Datastore Garbage collection in #{c.total_time}s")
  end
end

# Run it!
run()
