# = Class: resolver::params
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
# class resolver::someclass( packages = $resolver::params::some_param
# ) inherits resolver::params {
# ...do something
# }
#
# class { 'resolver::params' : }
#
# include resolver::params
#
class resolver::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports resolver version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $resolver_configs = {
      '/etc/resolv.conf'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0444',
        'content' => template('resolver/resolv.conf.erb'),
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
