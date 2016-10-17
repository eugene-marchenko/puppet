# Class: monit
#
# This module manages monit packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the monit packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $monit::params::monit_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $monit::params::monit_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $monit::params::monit_configs.
#
# == Requires:
#
# stdlib, monit::params
#
# == Sample Usage:
#
# include monit
#
# class { 'monit' : }
#
# class { 'monit' : installed => false }
#
# class { 'monit' : packages => hiera('some_other_packages') }
#
class monit(
  $installed = true,
  $packages  = hiera('monit_packages'),
  $defaults  = hiera('monit_package_defaults'),
  $configs   = hiera('monit_configs'),
) inherits monit::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      monit::package { 'monit-packages':
        packages => $packages,
        defaults => $defaults,
      }
      monit::config  { 'monit-configs' :  configs => $configs }
      include monit::service

      anchor{'monit::begin':}        -> Monit::Package[monit-packages]
      Monit::Package[monit-packages] -> Monit::Config[monit-configs]
      Monit::Config[monit-configs]   -> anchor{'monit::end':}

      if defined(Class[monit::service]) {
        Monit::Config[monit-configs]   ~> Class[monit::service]
      }

      motd::register { 'Monit' : }

    }
    false: {
      monit::package { 'monit-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'monit-package' |> {
        ensure => 'purged',
      }

      anchor{'monit::begin':}        -> Monit::Package[monit-packages]
      Monit::Package[monit-packages] -> anchor{'monit::end':}
    }
    # Do Nothing.
    default: {}
  }
}
