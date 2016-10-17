# = Class: rsyslog::params
#
# This module manages default parameters. It does the heavy lifting
# to determine operating system specific parameters.
#
# == Parameters:
#
# None.
#
# == Actions:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# class rsyslog::someclass( packages = $rsyslog::params::some_param
# ) inherits rsyslog::params {
# ...do something
# }
#
# class { 'rsyslog::params' : }
#
# include rsyslog::params
#
class rsyslog::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports rsyslog version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {

    # Default resources
    $rsyslog_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'rsyslog-package',
    }
    $rsyslog_services = {
      'rsyslog' => {
        'ensure'  => 'running',
        'enable'  => true,
      }
    }
    $rsyslog_packages = {
      'rsyslog'         => {},
      'rsyslog-doc'     => {},
      'rsyslog-relp'    => {},
    }
    $rsyslog_configs = {
      '/etc/rsyslog.conf'               => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('rsyslog/Ubuntu/precise/rsyslog.conf.erb'),
          default   => template('rsyslog/Ubuntu/rsyslog.conf.erb'),
        },
      },
      '/etc/default/rsyslog'            => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('rsyslog/Ubuntu/precise/default.erb'),
          default   => template('rsyslog/Ubuntu/default.erb'),
        },
      },
      '/etc/rsyslog.d'                  => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/etc/rsyslog.d/50-default.conf'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
     '/etc/logrotate.d/rsyslog' => {
  'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
  'content' => $::lsbdistcodename ? {
    'precise' => template('rsyslog/Ubuntu/precise/logrotate.conf.erb'),
          default   => template('rsyslog/Ubuntu/logrotate.conf.erb'),
    }
  }
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
