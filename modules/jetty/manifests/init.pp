# Class: jetty
#
# This module manages jetty packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the jetty packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $jetty::params::jetty_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $jetty::params::jetty_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $jetty::params::jetty_configs.
#
# == Requires:
#
# stdlib, jetty::params
#
# == Sample Usage:
#
# include jetty
#
# class { 'jetty' : }
#
# class { 'jetty' : installed => false }
#
# class { 'jetty' : packages => hiera('some_other_packages') }
#
class jetty(
  $installed = true,
  $packages  = hiera('jetty_packages'),
  $defaults  = hiera('jetty_package_defaults'),
  $configs   = hiera('jetty_configs'),
) inherits jetty::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      jetty::package { 'jetty-packages':
        packages => $packages,
        defaults => $defaults,
      }
      jetty::config  { 'jetty-configs' :  configs => $configs }
      include jetty::service
      include solr::newrelic
      anchor{'jetty::begin':}        -> Jetty::Package[jetty-packages]
      Jetty::Package[jetty-packages] -> Jetty::Config[jetty-configs]
      Jetty::Config[jetty-configs]   -> anchor{'jetty::end':}

      if defined(Class[jetty::service]) {
        Jetty::Config[jetty-configs]   ~> Class[jetty::service]
      }

      motd::register { 'Jetty' : }

    }
    false: {
      jetty::package { 'jetty-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'jetty-package' |> {
        ensure => 'purged',
      }

      anchor{'jetty::begin':}        -> Jetty::Package[jetty-packages]
      Jetty::Package[jetty-packages] -> anchor{'jetty::end':}
    }
    # Do Nothing.
    default: {}
  }
}
