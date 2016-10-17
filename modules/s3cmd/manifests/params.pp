# = Class: s3cmd::params
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
# class s3cmd::someclass(
#   packages = $s3cmd::params::some_param
# ) inherits s3cmd::params {
# ...do something
# }
#
# class { 's3cmd::params' : }
#
# include s3cmd::params
#
class s3cmd::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $s3cmd_packages = {
      's3cmd' => {},
    }
    $s3cmd_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 's3cmd-package',
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
