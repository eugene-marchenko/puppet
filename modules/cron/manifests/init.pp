# Class: cron
#
# This module manages cron packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the cron packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $cron::params::cron_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $cron::params::cron_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $cron::params::cron_configs.
#
# == Requires:
#
# stdlib, cron::params
#
# == Sample Usage:
#
# include cron
#
# class { 'cron' : }
#
# class { 'cron' : installed => false }
#
# class { 'cron' : packages => hiera('some_other_packages') }
#
class cron(
  $installed = true,
  $packages  = hiera('cron_packages'),
  $defaults  = hiera('cron_package_defaults'),
  $configs   = hiera('cron_configs'),
) inherits cron::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      cron::package { 'cron-packages':
        packages => $packages,
        defaults => $defaults,
      }
      cron::config  { 'cron-configs' :  configs => $configs }
      include cron::service

      anchor{'cron::begin':}        -> Cron::Package[cron-packages]
      Cron::Package[cron-packages] -> Cron::Config[cron-configs]
      Cron::Config[cron-configs]   -> anchor{'cron::end':}

      if defined(Class[cron::service]) {
        Cron::Config[cron-configs]   ~> Class[cron::service]
      }
    }
    false: {
      cron::package { 'cron-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'cron-package' |> {
        ensure => 'purged',
      }

      anchor{'cron::begin':}        -> Cron::Package[cron-packages]
      Cron::Package[cron-packages] -> anchor{'cron::end':}
    }
    # Do Nothing.
    default: {}
  }
}
