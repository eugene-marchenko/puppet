# = Class: skeleton::params
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
# class skeleton::someclass( packages = $skeleton::params::some_param
# ) inherits skeleton::params {
# ...do something
# }
#
# class { 'skeleton::params' : }
#
# include skeleton::params
#
class skeleton::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports skeleton version >= ${supportedversion}")
}

case $::osfamily {
  /Debian/: {
    $provider       = 'apt'
    $packages       = [ 'skeleton' ]
    $packages_tag   = 'skeleton-package'
    $conf_file      = 'skeleton/debian/skeleton.conf.erb'
    $defaults_conf  = 'skeleton/debian/default.erb'
    $configs_tag    = 'skeleton-config'
    $services       = [ 'skeleton' ]
    $services_tag   = 'skeleton-service'
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
