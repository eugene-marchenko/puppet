#
# validate_xml.rb
#

module Puppet::Parser::Functions
  newfunction(:validate_xml, :type => :rvalue, :doc => <<-EOS
Returns the contents of a file after validating it as xml
    EOS
  ) do |arguments|

    class HTTPError < Puppet::Error; end

    raise(Puppet::ParseError, "validate_xml(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    contents = arguments[0]

    unless contents.is_a?(String)
      raise(Puppet::ParseError, 'validate_xml(): Requires string to work with')
    end

    require 'xmlsimple'

    begin
      xmldoc = XmlSimple.xml_in(contents)
    rescue REXML::ParseException => e
      raise(Puppet::ParseError, "validate_xml(): Invalid or malformatted XML #{e.message}")
    end

    return contents
  end
end

# vim: set ts=2 sw=2 et :
