# = Class: dhcp::params
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
# class dhcp::someclass( packages = $dhcp::params::some_param
# ) inherits dhcp::params {
# ...do something
# }
#
# class { 'dhcp::params' : }
#
# include dhcp::params
#
class dhcp::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports dhcp version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $dhcp_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'dhcp-package',
    }
    $dhcp_packages = {
      'isc-dhcp-client'        => {},
    }
    $dhcp_configs = {
      '/etc/dhcp/dhclient.conf'  => {
        'ensure'  => 'present',
        'path'    => '/etc/dhcp/dhclient.conf',
        'line'    => template('dhcp/dhcp_prepend.erb'),
      },
    }
    $dhcp_services = {
      '/etc/init.d/networking restart'  => {
        'logoutput'   => 'on_failure',
        'refreshonly' => true,
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
