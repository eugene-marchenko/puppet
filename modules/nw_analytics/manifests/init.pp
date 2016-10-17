# Class: nw_analytics
#
# This module manages nw_analytics packages, configs, files and scripts.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the nw_analytics packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $nw_analytics::params::nw_analytics_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $nw_analytics::params::nw_analytics_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $nw_analytics::params::nw_analytics_configs.
#
# == Requires:
#
# stdlib, nw_analytics::params
#
# == Sample Usage:
#
# include nw_analytics
#
# class { 'nw_analytics' : }
#
# class { 'nw_analytics' : installed => false }
#
# class { 'nw_analytics' : packages => hiera('some_other_packages') }
#
class nw_analytics(
  $installed = true,
  $packages  = hiera('nw_analytics_packages'),
  $defaults  = hiera('nw_analytics_package_defaults'),
  $configs   = hiera('nw_analytics_configs'),
) inherits nw_analytics::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      nw_analytics::package { 'nw_analytics-packages':
        packages => $packages,
        defaults => $defaults,
      }
      nw_analytics::config  { 'nw_analytics-configs' :  configs => $configs }

      anchor{'nw_analytics::begin':}        -> Nw_analytics::Package[nw_analytics-packages]
      Nw_analytics::Package[nw_analytics-packages] -> Nw_analytics::Config[nw_analytics-configs]
      Nw_analytics::Config[nw_analytics-configs]   -> anchor{'nw_analytics::end':}

      motd::register { 'NW-Analytics' : }

    }
    false: {
      nw_analytics::package { 'nw_analytics-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'nw_analytics-package' |> {
        ensure => 'purged',
      }

      anchor{'nw_analytics::begin':}        -> Nw_analytics::Package[nw_analytics-packages]
      Nw_analytics::Package[nw_analytics-packages] -> anchor{'nw_analytics::end':}
    }
    # Do Nothing.
    default: {}
  }
}
