# = Class: motd::params
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
# class motd::someclass( packages = $motd::params::some_param
# ) inherits motd::params {
# ...do something
# }
#
# class { 'motd::params' : }
#
# include motd::params
#
class motd::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports motd version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $motd_local_file = '/etc/motd.tail'
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
