# Class: roles::logserver
#
# This class installs logserver resources
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
class roles::logserver() {

  include roles::base
  include logstash

  apt::source { 'wolfnet' :
    location => 'http://ppa.launchpad.net/wolfnet/logstash/ubuntu',
    release  => 'precise',
    repos    => 'main',
    key      => '28B04E4A',
  }

  file { 'logstash':
    ensure => present,
    mode   => '0644',
    owner  => root,
    group  => root,
    path   => '/etc/default/logstash',
    source => 'puppet:///modules/logstash/default',
  }

  logstash::input::file { 'syslog':
    type => 'syslog',
    path => [ '/var/log/syslog', '/var/log/remotelogs/*.log',
      '/var/log/*.log', '/var/log/remotelogs/varnish/*.log' ],
  }

  logstash::output::redis { 'redis':
    host      => [ 'grapher.ec2.thedailybeast.com' ],
    data_type => 'list',
    key       => 'logstash',
    batch     => true,
  }

  # Get the remote log directory from facts if available
  $remote_log_dir = $::remote_log_directory ? {
    /''|undef/  => '/var/log/remotelogs',
    default     => $::remote_log_directory,
  }

  $device = $::logserver_mount_device ? {
    /''|undef/  => '/dev/mapper/syslog--data-vol01',
    default     => $::logserver_mount_device,
  }

  $fstype = $::logserver_mount_fstype ? {
    /''|undef/  => 'xfs',
    default     => $::logserver_mount_fstype,
  }

  exec { "logserver(mkdir -p ${remote_log_dir})" :
    command => "mkdir -p ${remote_log_dir}",
    unless  => "test -d ${remote_log_dir}",
  }

  mount { $remote_log_dir :
    ensure  => 'mounted',
    device  => $device,
    options => 'defaults',
    fstype  => $fstype,
  }

  # Create the DynaFile template
  rsyslog::config::file { '05-dyna-template' :
    content => "\$template DynaFile,\"${remote_log_dir}/system-%HOSTNAME%.log\"\n",
  }

  # Use the DynaFile template except for the current host
  rsyslog::config::property { '49-remote-logs' :
    property    => ':hostname',
    comparison  => '!isequal',
    value       => $::hostname,
    destination => '-?DynaFile',
  }

  # Setup log rotation
  logrotate::rule { 'remotelogs' :
    path         => "${remote_log_dir}/*.log",
    compress     => true,
    missingok    => true,
    rotate       => '30',
    rotate_every => 'day',
    postrotate   => 'reload rsyslog >/dev/null 2>&1 || true',
  }

  motd::register { 'Logserver' : }

  # Use chaining to order the resources
  Class[roles::base]
  -> Exec["logserver(mkdir -p ${remote_log_dir})"]
  -> Mount[$remote_log_dir]
  -> Rsyslog::Config::File['05-dyna-template']
  -> Rsyslog::Config::Property['49-remote-logs']
  -> Logrotate::Rule[remotelogs]
}
