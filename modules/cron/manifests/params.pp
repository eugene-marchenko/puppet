# = Class: cron::params
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
# class cron::someclass( packages = $cron::params::some_param
# ) inherits cron::params {
# ...do something
# }
#
# class { 'cron::params' : }
#
# include cron::params
#
class cron::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports cron version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $cron_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'cron-package',
    }
    $cron_services = {
      'cron' => {
        'ensure'  => 'running',
        'enable'  => true,
      }
    }
    $cron_packages = {
      'cron'        => {},
    }
    $cron_configs = {
      '/etc/crontab'      => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
      '/etc/default/cron' => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('cron/Ubuntu/precise/default.erb'),
          default   => template('cron/Ubuntu/default.erb'),
        }
      },
      '/etc/cron.d'       => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/etc/cron.hourly'  => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/etc/cron.daily'   => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/etc/cron.weekly'  => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/etc/cron.monthly' => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
