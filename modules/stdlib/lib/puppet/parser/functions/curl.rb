#
# curl.rb
#

module Puppet::Parser::Functions
  newfunction(:curl, :type => :rvalue, :doc => <<-EOS
Returns the contents of a web request
    EOS
  ) do |arguments|

    class HTTPError < Puppet::Error; end

    raise(Puppet::ParseError, "curl(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    arg = arguments[0]
    username = arguments[1] || nil
    password = arguments[2] || nil
    authtypes = arguments[3] || :basic

    unless arg.is_a?(String)
      raise(Puppet::ParseError, 'curl(): Requires string to work with')
    end

    unless arg =~ /https?:\/\//
      raise(Puppet::ParseError, 'curl(): Malformatted URL')
    end

    require 'curb'

    curl = Curl::Easy.new(arg)
    curl.username = username if username
    curl.password = password if password
    curl.http_auth_types = authtypes
    curl.perform

    unless curl.response_code == 200
      raise(HTTPError, "curl(#{arg}): Response returned #{curl.response_code}")
    end

    return curl.body_str
  end
end

# vim: set ts=2 sw=2 et :
