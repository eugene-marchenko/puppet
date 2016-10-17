# = Class: users::params
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
# class users::someclass( shell = $users::params::shell
# ) inherits users::params {
# ...do something
# }
#
# class { 'users::params' : }
#
# include users::params
#
class users::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  'ubuntu': {
    case $::lsbdistcodename {
      default: {
        $groups = {
          'members' => [ 'sysadmins' ],
        }
        $users_config   = {
          'root' => {
            'shell'       => '/bin/bash',
            'home'        => '/root',
            'uid'         => '0',
            'gid'         => '0',
            'groups'      => [],
            'password'    => '',
            'ssh_pub_key' => '',
          },
        }
        $groups_config  = {
          'sysadmins' => {
            'members'   => [ 'root' ],
            'gid'       => '500',
          },
        }
        $shell          = '/bin/bash'
      }
    }
  }
  default: {fail("Module ${module_name} does not support $::{operatingsystem}")}
  }
}
