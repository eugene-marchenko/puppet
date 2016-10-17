# = Class: logrotate::params
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
# class logrotate::someclass( packages = $logrotate::params::some_param
# ) inherits logrotate::params {
# ...do something
# }
#
# class { 'logrotate::params' : }
#
# include logrotate::params
#
class logrotate::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports logrotate version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $logrotate_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'logrotate-package',
    }
    $logrotate_packages = {
      'logrotate'        => {},
    }
    $logrotate_configs = {
      '/etc/logrotate.conf'       => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
      '/etc/cron.daily/logrotate' => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/etc/logrotate.d'          => {
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
