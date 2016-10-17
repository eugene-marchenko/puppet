# = Class: ruby::params
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
# class ruby::someclass( packages = $python::params::some_param
# ) inherits ruby::params {
# ...do something
# }
#
# class { 'ruby::params' : }
#
# include ruby::params
#
class ruby::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    case $::lsbdistcodename {
      default: {
        $packages = {
          'ruby'        => {},
          'ruby1.8'     => {},
          'ruby1.8-dev' => {},
          'libruby'     => {},
          'libruby1.8'  => {},
          'rubygems'    => {},
        }
        $defaults = {
          'provider'  => 'apt',
          'ensure'    => 'latest',
          'tag'       => 'ruby-package',
        }
        $gem_packages = [
          'curb',
          'nokogiri',
          'highline',
        ]
      }
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
