# Class: sysctl
#
# This module manages sysctl configs, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the sysctl configs are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $sysctl::params::sysctl_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $sysctl::params::sysctl_package_defaults.
#
# $configs::        The configs to install. Must be a Hash. Defaults to
#                   $sysctl::params::sysctl_configs.
#
# == Requires:
#
# stdlib, sysctl::params
#
# == Sample Usage:
#
# include sysctl
#
# class { 'sysctl' : }
#
# class { 'sysctl' : installed => false }
#
# class { 'sysctl' : configs => hiera('some_other_configs') }
#
class sysctl(
  $installed = true,
  $packages  = hiera('sysctl_packages'),
  $defaults  = hiera('sysctl_package_defaults'),
  $configs   = hiera('sysctl_configs'),
) inherits sysctl::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      sysctl::package { 'sysctl-packages':
        packages => $packages,
        defaults => $defaults,
      }
      sysctl::config  { 'sysctl-configs' :  configs => $configs }
      include sysctl::service

      anchor{'sysctl::begin':}         -> Sysctl::Package[sysctl-packages]
      Sysctl::Package[sysctl-packages] -> Sysctl::Config[sysctl-configs]
      Sysctl::Config[sysctl-configs]   -> anchor{'sysctl::end':}

      if defined(Class[sysctl::service]) {
        Sysctl::Config[sysctl-configs]   ~> Class[sysctl::service]
      }

      motd::register { 'Sysctl' : }

    }
    # Do Nothing. sysctl is a core service.
    false: { }
    # Do Nothing.
    default: {}
  }
}
