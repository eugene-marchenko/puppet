# Class: roles::varnishserver
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
# include roles::varnishserver
#
# class { 'roles::varnishserver' : }
#
#
class roles::varnishserver() {

  include roles::base
  include roles::backports

  if $::varnish_storage_file {
    $varnish_storage_file_dir = dirname($::varnish_storage_file)
  } else {
    $varnish_storage_file_dir = '/var/lib/varnish'
  }

  exec { "varnishserver(mkdir -p ${varnish_storage_file_dir})" :
    command => "mkdir -p ${varnish_storage_file_dir}",
    unless  => "test -d ${varnish_storage_file_dir}"
  }

  include varnish

  # Recommendations from http://varnish-cache.org/wiki/Performance
  sysctl::option { 'net.ipv4.ip_local_port_range' : value => '1024 65535' }
  sysctl::option { 'net.core.rmem_max' :            value => '16777216' }
  sysctl::option { 'net.core.wmem_max' :            value => '16777216' }
  sysctl::option { 'net.ipv4.tcp_rmem' :            value => '4096 87380 16777216' }
  sysctl::option { 'net.ipv4.tcp_wmem' :            value => '4096 65536 16777216' }
  sysctl::option { 'net.ipv4.tcp_fin_timeout' :     value => '3' }
  sysctl::option { 'net.core.netdev_max_backlog' :  value => '30000' }
  sysctl::option { 'net.ipv4.tcp_no_metrics_save' : value => '1' }
  sysctl::option { 'net.ipv4.tcp_syncookies' :      value => '0' }
  sysctl::option { 'net.ipv4.tcp_max_orphans' :     value => '262144' }
  sysctl::option { 'net.ipv4.tcp_max_syn_backlog' : value => '262144' }

  # Tests good with 4. The Varnish recommended setting of 2 for each of the
  # following below broke the ELB causing connection drops and a blank page
  # displayed in clients browsers. Each of these numbers corresponds to ~35
  # seconds so 4*35 = 140 seconds
  sysctl::option { 'net.ipv4.tcp_synack_retries' :  value => '4' }
  sysctl::option { 'net.ipv4.tcp_syn_retries' :     value => '4' }

  # Sometimes the parent process dies, Monit is there to restart it.
  monit::monitor::service { 'varnishd' :
    pidfile    => '/var/run/varnishd.pid',
    initscript => '/etc/init.d/varnish',
  }

  # By default, log varnish logs to local disk, the following sets up a
  # template to format in NCSA format.
  rsyslog::config::file { '06-ncsa-template' :
    content => '$template NCSA,"%msg:2:$%\n"',
  }

  # Due to excessive logging from production varnish servers, increase
  # ratelimiting.
  rsyslog::config::file { '08-rate-limiting' :
    content => "\$SystemLogRateLimitInterval 10\n\$SystemLogRateLimitBurst 5000\n"
  }

  # Setup NCSA logging
  rsyslog::config::property { '38-varnish-ncsa-log' :
    property    => ':syslogtag',
    comparison  => 'contains',
    value       => '[varnishncsa]',
    destination => '/mnt/log/varnish/varnishncsa.log;NCSA',
    discard     => false,
  }

  # Setup traditional logging, discard so it doesn't filter through to
  # /var/log/syslog
  rsyslog::config::property { '39-varnish-log' :
    property    => ':syslogtag',
    comparison  => 'contains',
    value       => '[varnishncsa]',
    destination => '/mnt/log/varnish/varnish-syslog-traditional.log',
  }

  # Rotate those logs out, keep 30 days worth.
  logrotate::rule { 'varnish-syslog' :
    path          => [ '/mnt/log/varnish/varnishncsa.log',
                      '/mnt/log/varnish/varnish-syslog-traditional.log',
                    ],
    compress      => true,
    delaycompress => true,
    missingok     => true,
    rotate        => '30',
    rotate_every  => 'day',
    postrotate    => 'reload rsyslog >/dev/null 2>&1 || true'
  }

  # allow jenkins to clear cache
  if ( $::env != prod ) {
    sudo::config::sudoer { 'jenkins-varnishrestart':
      content => 'jenkins ALL=(ALL) NOPASSWD: /etc/init.d/varnish restart'
    }
  }

  realize Package['python-varnish']

  Class[roles::base]
  -> Exec["varnishserver(mkdir -p ${varnish_storage_file_dir})"]
  -> Package['python-varnish']
  -> Class[varnish]
  -> Sysctl::Option['net.ipv4.ip_local_port_range']
  -> Sysctl::Option['net.core.rmem_max']
  -> Sysctl::Option['net.core.wmem_max']
  -> Sysctl::Option['net.ipv4.tcp_rmem']
  -> Sysctl::Option['net.ipv4.tcp_wmem']
  -> Sysctl::Option['net.ipv4.tcp_fin_timeout']
  -> Sysctl::Option['net.core.netdev_max_backlog']
  -> Sysctl::Option['net.ipv4.tcp_no_metrics_save']
  -> Sysctl::Option['net.ipv4.tcp_syncookies']
  -> Sysctl::Option['net.ipv4.tcp_max_orphans']
  -> Sysctl::Option['net.ipv4.tcp_max_syn_backlog']
  -> Sysctl::Option['net.ipv4.tcp_synack_retries']
  -> Sysctl::Option['net.ipv4.tcp_syn_retries']
  -> Monit::Monitor::Service['varnishd']
  -> Rsyslog::Config::File['06-ncsa-template']
  -> Rsyslog::Config::File['08-rate-limiting']
  -> Rsyslog::Config::Property['38-varnish-ncsa-log']
  -> Rsyslog::Config::Property['39-varnish-log']
  -> Logrotate::Rule['varnish-syslog']
}
