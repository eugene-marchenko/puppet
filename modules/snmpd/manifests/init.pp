# Class: snmpd
#
# This module manages snmpd packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the snmpd packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $snmpd::params::snmpd_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $snmpd::params::snmpd_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $snmpd::params::snmpd_configs.
#
# == Requires:
#
# stdlib, snmpd::params
#
# == Sample Usage:
#
# include snmpd
#
# class { 'snmpd' : }
#
# class { 'snmpd' : installed => false }
#
# class { 'snmpd' : packages => hiera('some_other_packages') }
#
class snmpd(
  $installed = true,
  $packages  = hiera('snmpd_packages'),
  $defaults  = hiera('snmpd_package_defaults'),
  $configs   = hiera('snmpd_configs'),
) inherits snmpd::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      snmpd::package { 'snmpd-packages':
        packages => $packages,
        defaults => $defaults,
      }
      snmpd::config  { 'snmpd-configs' :  configs => $configs }
      include snmpd::service

      anchor{'snmpd::begin':}        -> Snmpd::Package[snmpd-packages]
      Snmpd::Package[snmpd-packages] -> Snmpd::Config[snmpd-configs]
      Snmpd::Config[snmpd-configs]   -> anchor{'snmpd::end':}

      if defined(Class[snmpd::service]) {
        Snmpd::Config[snmpd-configs]   ~> Class[snmpd::service]
      }

      motd::register { 'Snmpd' : }

    }
    false: {
      snmpd::package { 'snmpd-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'snmpd-package' |> {
        ensure => 'purged',
      }

      anchor{'snmpd::begin':}        -> Snmpd::Package[snmpd-packages]
      Snmpd::Package[snmpd-packages] -> anchor{'snmpd::end':}
    }
    # Do Nothing.
    default: {}
  }
}
