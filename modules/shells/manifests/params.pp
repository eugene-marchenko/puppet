# = Class: shells::params
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
# class shells::someclass( packages = $shells::params::some_param
# ) inherits shells::params {
# ...do something
# }
#
# class { 'shells::params' : }
#
# include shells::params
#
class shells::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports shells version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $shells_allowed = [
      '/bin/sh',
      '/bin/dash',
      '/bin/bash',
      '/usr/bin/tmux',
      '/usr/bin/screen',
      '/bin/csh',
      '/bin/tcsh',
      '/bin/ksh',
      '/bin/false',
    ]
    $shells_configs = {
      '/etc/shells'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => template('shells/shells.erb'),
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
