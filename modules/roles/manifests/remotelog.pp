# Class: roles::remotelog
#
# This class sets up remote logging to a central syslog server
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
# include roles::remotelog
#
# class { 'roles::remotelog' : }
#
#
class roles::remotelog() {

  include roles::base

  # Optional facts
  $logserver = $::syslog_server ? {
    /''|undef/  => 'syslog.ec2.thedailybeast.com',
    default     => $::syslog_server,
  }

  $syslog_destination = $::syslog_remote_protocol ? {
    /tcp/       => "@@${logserver};jsontemplate",
    /relp/      => ":omrelp:${logserver}:2514;jsontemplate",
    default     => "@${logserver};jsontemplate",
  }

  rsyslog::config::selector { '55-catch-all' :
    template_name  => '$template jsontemplate,"%HOSTNAME% {\"event\":{\"p_proc\":\"%programname%\",\"p_sys\":\"%hostname%\",\"time\":\"%timestamp:::date-rfc3339%\"},\"message\":{\"raw_msg\":\"%rawmsg%\"}}\n",json',
    selector       => '*.*',
    destination    => $syslog_destination,
    comment        => 'Centrally log all logs',
    discard        => false,
  }

  Class[roles::base]
  -> Rsyslog::Config::Selector['55-catch-all']
}
