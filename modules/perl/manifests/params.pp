# = Class: perl::params
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
# class perl::someclass( packages = $perl::params::some_param
# ) inherits perl::params {
# ...do something
# }
#
# class { 'perl::params' : }
#
# include perl::params
#
class perl::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    case $::lsbdistcodename {
      default: {
        $perl_packages = {
          'perl'          => {},
          'perl-base'     => {},
          'perl-modules'  => {},
          'perl-doc'      => {},
        }
        $perl_package_defaults = {
          'ensure'    => 'latest',
          'provider'  => 'apt',
          'tag'       => 'perl-package',
        }
      }
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
