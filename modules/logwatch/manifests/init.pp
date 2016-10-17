# Class: logwatch
#
# This module manages logwatch packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the logwatch packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $logwatch::params::logwatch_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $logwatch::params::logwatch_package_defaults.
#
# == Requires:
#
# stdlib, logwatch::params
#
# == Sample Usage:
#
# include logwatch
#
# class { 'logwatch' : }
#
# class { 'logwatch' : installed => false }
#
# class { 'logwatch' : packages => hiera('some_other_packages') }
#
class logwatch(
  $installed  = true,
  $packages   = hiera('logwatch_packages'),
  $defaults   = hiera('logwatch_package_defaults'),
) inherits logwatch::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$defaults)

  case $installed {
    true: {
      logwatch::package { 'logwatch-packages':
        packages => $packages,
        defaults => $defaults,
      }

      anchor{'logwatch::begin':}         -> Logwatch::Package[logwatch-packages]
      Logwatch::Package[logwatch-packages]  -> anchor{'logwatch::end':}

      motd::register { 'Logwatch' : }

    }
    false: {
      logwatch::package { 'logwatch-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'logwatch-package' |> {
        ensure => 'purged',
      }

      anchor{'logwatch::begin':}         -> Logwatch::Package[logwatch-packages]
      Logwatch::Package[logwatch-packages]  -> anchor{'logwatch::end':}
    }
    # Do Nothing.
    default: {}
  }
}
