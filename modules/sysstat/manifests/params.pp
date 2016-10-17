# = Class: sysstat::params
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
# class sysstat::someclass( packages = $java::params::some_param
# ) inherits sysstat::params {
# ...do something
# }
#
# class { 'sysstat::params' : }
#
# include sysstat::params
#
class sysstat::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    case $::lsbdistcodename {
      'precise': {
        $packages = [
          'sysstat',
        ]
      }
      default: {
        $packages = [
          'sysstat',
        ]
      }
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
