module Puppet::Parser::Functions
  newfunction(:ec2metadata, :type => :rvalue) do |args|

    raise(Puppet::ParseError, "ec2metadata(): Wrong number of arguments " +
        "given (#{args.size} for 1)") if args.size != 1

    var = args[0]
    cmd = "/usr/bin/ec2metadata --#{var}"
    `#{cmd}`.chomp
  end
end
