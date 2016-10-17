# = Class: skeleton_pkg_only::params
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
# class skeleton_pkg_only::someclass(
#   packages = $skeleton_pkg_only::params::some_param
# ) inherits skeleton_pkg_only::params {
# ...do something
# }
#
# class { 'skeleton_pkg_only::params' : }
#
# include skeleton_pkg_only::params
#
class skeleton_pkg_only::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supportsskeleton_pkg_only version >= \
${supportedversion}")
}

case $::osfamily {
  /Debian/: {
    $provider       = 'apt'
    $packages       = {
      'skeleton_pkg_only' => {}
    }
    $packages_tag   = 'skeleton_pkg_only-package'
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
