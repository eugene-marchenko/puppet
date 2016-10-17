# Class: sasl
#
# This module manages sasl packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the sasl packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $sasl::params::sasl_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $sasl::params::sasl_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $sasl::params::sasl_configs.
#
# == Requires:
#
# stdlib, sasl::params
#
# == Sample Usage:
#
# include sasl
#
# class { 'sasl' : }
#
# class { 'sasl' : installed => false }
#
# class { 'sasl' : packages => hiera('some_other_packages') }
#
class sasl(
  $installed = true,
  $packages  = hiera('sasl_packages'),
  $defaults  = hiera('sasl_package_defaults'),
  $configs   = hiera('sasl_configs'),
) inherits sasl::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      sasl::package { 'sasl-packages':
        packages => $packages,
        defaults => $defaults,
      }
      sasl::config  { 'sasl-configs' :  configs => $configs }
      include sasl::service

      # If postfix is present, add postfix user to sasl group
      if defined(Class[postfix]) {
        user { 'postfix-sasl' :
          name    => 'postfix',
          groups  => [ 'sasl' ],
          require => Class[postfix],
        }
        anchor{'sasl::begin':}        -> Sasl::Package[sasl-packages]
        Sasl::Package[sasl-packages]  -> Sasl::Config[sasl-configs]
        Sasl::Config[sasl-configs]    -> User[postfix-sasl]
        User[postfix-sasl]            -> anchor{'sasl::end':}
      } else {
        anchor{'sasl::begin':}        -> Sasl::Package[sasl-packages]
        Sasl::Package[sasl-packages]  -> Sasl::Config[sasl-configs]
        Sasl::Config[sasl-configs]    -> anchor{'sasl::end':}
      }

      if defined(Class[sasl::service]) {
        Sasl::Config[sasl-configs]    ~> Class[sasl::service]
      }

      motd::register { 'Sasl' : }

    }
    false: {
      sasl::package { 'sasl-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'sasl-package' |> {
        ensure => 'purged',
      }

      anchor{'sasl::begin':}        -> Sasl::Package[sasl-packages]
      Sasl::Package[sasl-packages]  -> anchor{'sasl::end':}
    }
    # Do Nothing.
    default: {}
  }
}
