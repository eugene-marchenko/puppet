# Class: logrotate
#
# This module manages logrotate packages and rule files
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the logrotate packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $logrotate::params::logrotate_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $logrotate::params::logrotate_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $logrotate::params::logrotate_configs.
#
# == Requires:
#
# stdlib, logrotate::params
#
# == Sample Usage:
#
# include logrotate
#
# class { 'logrotate' : }
#
# class { 'logrotate' : installed => false }
#
# class { 'logrotate' : packages => hiera('some_other_packages') }
#
class logrotate(
  $installed = true,
  $packages  = hiera('logrotate_packages'),
  $defaults  = hiera('logrotate_package_defaults'),
  $configs   = hiera('logrotate_configs'),
) inherits logrotate::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      logrotate::package { 'logrotate-packages':
        packages => $packages,
        defaults => $defaults,
      }
      logrotate::config  { 'logrotate-configs' :  configs => $configs }

      anchor{'logrotate::begin':}             -> Logrotate::Package[logrotate-packages]
      Logrotate::Package[logrotate-packages]  -> Logrotate::Config[logrotate-configs]
      Logrotate::Config[logrotate-configs]    -> anchor{'logrotate::end':}

      motd::register { 'Logrotate' : }

    }
    false: {
      logrotate::package { 'logrotate-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'logrotate-package' |> {
        ensure => 'purged',
      }

      anchor{'logrotate::begin':}             -> Logrotate::Package[logrotate-packages]
      Logrotate::Package[logrotate-packages]  -> anchor{'logrotate::end':}
    }
    # Do Nothing.
    default: {}
  }
}
