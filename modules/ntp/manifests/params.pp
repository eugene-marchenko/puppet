# = Class: ntp::params
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
# class ntp::someclass( packages = $ntp::params::some_param
# ) inherits ntp::params {
# ...do something
# }
#
# class { 'ntp::params' : }
#
# include ntp::params
#
class ntp::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports ntp version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    # Supported Facts
    # ...

    # Default parameters
    # ...

    # Default package/file/service params
    $package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'ntp-package',
    }
    $packages = {
      'ntp'        => {},
    }
    $config_defaults = {
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'tag'     => 'ntp-config',
    }
    $configs = {
      '/etc/ntp.conf'     => {
        'content' => $::lsbdistcodename ? {
          'precise' => template('ntp/Ubuntu/precise/ntp.conf.erb'),
          default   => template('ntp/Ubuntu/ntp.conf.erb'),
        }
      },
      '/etc/default/ntp'  => {
        'content' => $::lsbdistcodename ? {
          'precise' => template('ntp/Ubuntu/precise/default.erb'),
          default   => template('ntp/Ubuntu/default.erb'),
        }
      },
    }
    $service_defaults = {
      'ensure'  => 'running',
      'enable'  => true,
      'tag'     => 'ntp-service',
    }
    $services = {
      'ntp' => {},
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
