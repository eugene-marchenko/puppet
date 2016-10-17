# = Class: monit::params
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
# class monit::someclass( packages = $puppet::params::some_param
# ) inherits monit::params {
# ...do something
# }
#
# class { 'monit::params' : }
#
# include monit::params
#
class monit::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports monit version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {

    if $::monit_dot_dir {
      $monit_dot_dir = $::monit_dot_dir
    } else {
      $monit_dot_dir = '/etc/monit/conf.d'
    }

    $monit_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'monit-package',
    }
    $monit_services = {
      'monit' => {
        'ensure'  => 'running',
        'enable'  => true,
      }
    }
    $monit_packages = {
      'monit'        => {},
    }
    $monit_configs = {
      '/etc/monit/monitrc'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0600',
        'content' => $::lsbdistcodename ? {
          'precise' => template('monit/Ubuntu/precise/monitrc.erb'),
          default   => template('monit/Ubuntu/monitrc.erb'),
        }
      },
      '/etc/default/monit'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('monit/Ubuntu/precise/default.erb'),
          default   => template('monit/Ubuntu/default.erb'),
        }
      },
      "${monit_dot_dir}"      => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      }
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
