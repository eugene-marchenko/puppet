# = Class: java::params
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
# class java::someclass( packages = $java::params::some_param
# ) inherits java::params {
# ...do something
# }
#
# class { 'java::params' : }
#
# include java::params
#
class java::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports java version >= ${supportedversion}")
}

case $::osfamily {
  /Debian/: {
    $provider       = 'apt'
    $packages       = {
      'java-common'             => {},
      'openjdk-6-jre'           => {},
      'openjdk-6-jdk'           => {},
      'openjdk-6-jre-headless'  => {},
      'openjdk-6-jre-lib'       => {},
      'default-jre'             => {},
    }
    $packages_tag   = 'java-package'
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
