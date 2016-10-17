# = Class: sysctl::params
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
# class sysctl::someclass( packages = $puppet::params::some_param
# ) inherits sysctl::params {
# ...do something
# }
#
# class { 'sysctl::params' : }
#
# include sysctl::params
#
class sysctl::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports sysctl version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $sysctl_option_template = 'sysctl/Ubuntu/option.conf.erb'
    $sysctl_dot_dir = '/etc/sysctl.d'
    $sysctl_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'sysctl-package',
    }
    $sysctl_services = {
      'service procps start' => {
        'refreshonly' => true,
        'logoutput'   => 'on_failure',
      }
    }
    $sysctl_packages = {
      'procps'        => {},
    }
    $sysctl_configs = {
      '/etc/sysctl.conf'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
      "${sysctl_dot_dir}"   => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      }
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
