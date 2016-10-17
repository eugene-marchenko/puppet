# = Class: snmpd::params
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
# class snmpd::someclass( packages = $snmpd::params::some_param
# ) inherits snmpd::params {
# ...do something
# }
#
# class { 'snmpd::params' : }
#
# include snmpd::params
#
class snmpd::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports snmpd version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $snmpd_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'snmpd-package',
    }
    $snmpd_services = {
      'snmpd' => {
        'ensure'  => 'running',
        'enable'  => true,
      }
    }
    $snmpd_packages = {
      'snmpd'        => {},
    }
    $snmpd_configs = {
      '/etc/snmpd/snmpd.conf'     => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0600',
      },
      '/etc/snmpd/snmp.conf'      => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
      '/etc/snmpd/snmptrapd.conf' => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0600',
      },
      '/etc/default/snmpd'        => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
