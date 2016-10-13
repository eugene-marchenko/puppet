# Class: roles::logserver::varnish
#
# This class installs logserver resources for accepting remote varnish logs
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
# include roles::logserver
#
# class { 'roles::logserver' : }
#
#
class roles::logserver::varnish() {

  include roles::base
  include roles::logserver

  # Get the remote log directory from parent
  $remote_log_dir = $roles::logserver::remote_log_dir

  # Create the NCSA template
  rsyslog::config::file { '07-ncsa-template' :
    content => "\$template NCSA,\"%msg:2:$%\\n\"\n",
  }

  # Log NCSA logs using that template
  rsyslog::config::property { '35-varnish-remote-logs-ncsa' :
    property    => ':syslogtag',
    comparison  => 'contains',
    value       => 'varnishncsa',
    destination => "${remote_log_dir}/varnish/varnishncsa.log;NCSA",
    discard     => false,
  }

  # Log traditional syslog format as well
  rsyslog::config::property { '36-varnish-remote-logs' :
    property    => ':syslogtag',
    comparison  => 'contains',
    value       => 'varnishncsa',
    destination => "${remote_log_dir}/varnish/varnish-syslog-traditional.log",
  }

  # Setup log rotation
  logrotate::rule { 'varnish-remote-syslog' :
    path          => [ "${remote_log_dir}/varnish/varnishncsa.log",
                      "${remote_log_dir}/varnish/varnish-syslog-traditional.log",
                    ],
    compress      => true,
    missingok     => true,
    rotate        => '60',
    rotate_every  => 'day',
    postrotate    => 'reload rsyslog >/dev/null 2>&1 || true',
  }

  motd::register { 'Logserver::Varnish' : }

  # Use chaining to order the resources
  Class[roles::base]
  -> Rsyslog::Config::File['07-ncsa-template']
  -> Rsyslog::Config::Property['35-varnish-remote-logs-ncsa']
  -> Rsyslog::Config::Property['36-varnish-remote-logs']
  -> Logrotate::Rule['varnish-remote-syslog']
}
