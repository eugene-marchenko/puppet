# Class: sysstat::packages
#
# This module installs sysstat packages
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $packages::   The packages to install. This must be an array of package names
#               The default is taken from sysstat::params.
#
# $key::        If the packages variable is a hash, look for this key. Defaults
#               to 'packages'.
#
# $stage::      The stage that this class and all contained resources should
#               run in. The default is setup.
#
# == Requires:
#
# stdlib, sysstat::params
#
# == Sample Usage:
#
# include sysstat::packages
#
# class { 'sysstat::packages' : }
#
# class { 'sysstat::packages' :
#   packages => hiera('some_other_packages'),
#   key      => 'sysstat_packages',
# }
#
class sysstat::packages(
  $packages = $sysstat::params::packages,
  $key      = 'packages',
) inherits sysstat::params {

  include stdlib

  if is_hash($packages) {
    $packages_real = $packages[$key]
  } else {
    $packages_real = $packages
  }

  # Use module name to differentiate this resource from other
  # modules that also seek to ensure that this directory exists.
  exec { "make-${module_name}-/var/local/preseed" :
    command => 'mkdir -p /var/local/preseed',
    unless  => 'test -d /var/local/preseed',
  }

  file { "/var/local/preseed/${packages_real}.preseed":
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => [
      "puppet:///modules/sysstat/${::operatingsystem}/${::lsbdistcodename}/${packages_real}.preseed",
      "puppet:///modules/sysstat/${::operatingsystem}/${packages_real}.preseed",
      "puppet:///modules/sysstat/${packages_real}.preseed",
    ],
    require => Exec["make-${module_name}-/var/local/preseed"],
  }

  package { $packages_real :
    ensure       => latest,
    responsefile => "/var/local/preseed/${packages_real}.preseed",
    tag          => 'sysstat-package'
  }

}
