# Class: roles::varnishserver::remotelog
#
# This class installs varnish resources
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# None.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# include roles::varnishserver::remotelog
#
# class { 'roles::varnishserver::remotelog' : }
#
#
class roles::varnishserver::remotelog() {

  include roles::base

  $logserver = $::syslog_server ? {
    /''|undef/  => 'syslog.ec2.thedailybeast.com',
    default     => $::syslog_server,
  }

  $destination = $::varnish_syslog_remote_protocol ? {
    /tcp/       => "@@${logserver}",
    /relp/      => ":omrelp:${logserver}:2514",
    default     => "@${logserver}",
  }

  # Setup Remote logging
  rsyslog::config::property { '37-varnish-remotelog' :
    property    => ':syslogtag',
    comparison  => 'contains',
    value       => '[varnishncsa]',
    destination => $destination,
  }

  Class[roles::base] -> Rsyslog::Config::Property['37-varnish-remotelog']
}
