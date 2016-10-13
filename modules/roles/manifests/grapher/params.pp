# = Class: logstash::params
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
# class logstash::someclass(
#   packages = $logstash::params::some_param
# ) inherits logstash::params {
# ...do something
# }
#
# class { 'logstash::params' : }
#
# include logstash::params
#
class logstash::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $logstash_packages = {
      'logstash' => {},
    }
    $logstash_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'logstash-package',
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
