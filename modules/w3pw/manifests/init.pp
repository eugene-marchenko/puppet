# Class: w3pw
#
# This module manages w3pw packages, configs, files and scripts.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the w3pw packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $w3pw::params::w3pw_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $w3pw::params::w3pw_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $w3pw::params::w3pw_configs.
#
# == Requires:
#
# stdlib, w3pw::params
#
# == Sample Usage:
#
# include w3pw
#
# class { 'w3pw' : }
#
# class { 'w3pw' : installed => false }
#
# class { 'w3pw' : packages => hiera('some_other_packages') }
#
class w3pw(
  $installed = true,
  $packages  = hiera('w3pw_packages'),
  $defaults  = hiera('w3pw_package_defaults'),
  $configs   = hiera('w3pw_configs'),
) inherits w3pw::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      w3pw::package { 'w3pw-packages':
        packages => $packages,
        defaults => $defaults,
      }
      w3pw::config  { 'w3pw-configs' :  configs => $configs }

      anchor{'w3pw::begin':}        -> W3pw::Package[w3pw-packages]
      W3pw::Package[w3pw-packages] -> W3pw::Config[w3pw-configs]
      W3pw::Config[w3pw-configs]   -> anchor{'w3pw::end':}

      motd::register { 'W3pw' : }

    }
    false: {
      w3pw::package { 'w3pw-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'w3pw-package' |> {
        ensure => 'purged',
      }

      anchor{'w3pw::begin':}        -> W3pw::Package[w3pw-packages]
      W3pw::Package[w3pw-packages] -> anchor{'w3pw::end':}
    }
    # Do Nothing.
    default: {}
  }
}
