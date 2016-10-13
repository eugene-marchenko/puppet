# = Class: hosts::params
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
# class hosts::someclass( packages = $puppet::params::some_param
# ) inherits hosts::params {
# ...do something
# }
#
# class { 'hosts::params' : }
#
# include hosts::params
#
class hosts::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports hosts version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $hosts_configs = {
      '/etc/hosts'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0664',
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
