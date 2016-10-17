# = Class: ssh::params
#
# This module manages ssh default parameters. It does the heavy lifting
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
# class ssh::someclass( packagename = $ssh::params::packagename
# ) inherits ssh::params {
# ...do something
# }
#
# class { 'ssh::params' : }
#
# include ssh::params
#
class ssh::params  {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  'ubuntu': {
    case $::lsbdistcodename {
      default: {
        $packages     = [ 'openssh-server', 'openssh-client' ]
        $servicename  = 'ssh'
        $configfiles  = {
          '/etc/ssh/sshd_config'  => {
            ensure  => 'present',
            mode    => '0644',
            require => Class[ssh::package],
            notify  => Class[ssh::service],
          },
          '/etc/ssh/ssh_config'   => {
            ensure  => 'present',
            mode    => '0644',
            require => Class[ssh::package],
            },
          '/etc/default/ssh'      => {
            ensure  => 'present',
            mode    => '0644',
            require => Class[ssh::package],
            notify  => Class[ssh::service],
          },
        }
        $configdir    = '/etc/ssh'
      }
    }
  }
  default: {fail("Module ${module_name} does not support $::{operatingsystem}")}
  }
}
