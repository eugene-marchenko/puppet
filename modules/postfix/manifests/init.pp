# Class: postfix
#
# This module manages postfix packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the postfix packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $postfix::params::postfix_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $postfix::params::postfix_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $postfix::params::postfix_configs.
#
# == Requires:
#
# stdlib, postfix::params
#
# == Sample Usage:
#
# include postfix
#
# class { 'postfix' : }
#
# class { 'postfix' : installed => false }
#
# class { 'postfix' : packages => hiera('some_other_packages') }
#
class postfix(
  $installed = true,
  $packages  = hiera('postfix_packages'),
  $defaults  = hiera('postfix_package_defaults'),
  $configs   = hiera('postfix_configs'),
) inherits postfix::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      postfix::package { 'postfix-packages':
        packages => $packages,
        defaults => $defaults,
      }
      postfix::config  { 'postfix-configs' :  configs => $configs }
      include postfix::service

      anchor{'postfix::begin':}        -> Postfix::Package[postfix-packages]
      Postfix::Package[postfix-packages] -> Postfix::Config[postfix-configs]
      Postfix::Config[postfix-configs]   -> anchor{'postfix::end':}

      if defined(Class[postfix::service]) {
        Postfix::Config[postfix-configs]   ~> Class[postfix::service]
      }

      motd::register { 'Postfix' : }

    }
    false: {
      postfix::package { 'postfix-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'postfix-package' |> {
        ensure => 'purged',
      }

      anchor{'postfix::begin':}        -> Postfix::Package[postfix-packages]
      Postfix::Package[postfix-packages] -> anchor{'postfix::end':}
    }
    # Do Nothing.
    default: {}
  }
}
