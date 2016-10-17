# = Class: w3pw::params
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
# class w3pw::someclass( packages = $w3pw::params::some_param
# ) inherits w3pw::params {
# ...do something
# }
#
# class { 'w3pw::params' : }
#
# include w3pw::params
#
class w3pw::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports w3pw version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $w3pw_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'w3pw-package',
    }
    $w3pw_packages = {
      'w3pw'        => {},
    }
    $w3pw_configs = {
      '/usr/share/w3pw/lib/config.php'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'content' => $::lsbdistcodename ? {
          'precise' => template('w3pw/Ubuntu/precise/config.php.erb'),
          default   => template('w3pw/Ubuntu/config.php.erb'),
        }
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
