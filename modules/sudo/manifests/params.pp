# = Class: sudo::params
#
# This module manages user default parameters. It does the heavy lifting
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
# class sudo::someclass( sudoeres = $sudo::params::sudoers
# ) inherits sudo::params {
# ...do something
# }
#
# class { 'sudo::params' : }
#
# include sudo::params
#
class sudo::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  'ubuntu': {
    case $::lsbdistcodename {
      default: {
        $sudoers = [ 'sysadmins' ]
        $sudoers_path = '/etc/sudoers.d'
        $sudo_packagename = 'sudo'
        $sudo_packageensure = 'latest'
        $sudo_sudoersensure = 'present'
      }
    }
  }
  default: {fail("Module ${module_name} does not support $::{operatingsystem}")}
  }
}
