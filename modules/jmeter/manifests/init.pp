# Class: jmeter
#
# This module manages jmeter packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the jmeter packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $jmeter::params::jmeter_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $jmeter::params::jmeter_package_defaults.
#
# == Requires:
#
# stdlib, jmeter::params
#
# == Sample Usage:
#
# include jmeter
#
# class { 'jmeter' : }
#
# class { 'jmeter' : installed => false }
#
# class { 'jmeter' : packages => hiera('some_other_packages') }
#
class jmeter(
  $installed  = true,
  $packages   = hiera('jmeter_packages'),
  $defaults   = hiera('jmeter_package_defaults'),
) inherits jmeter::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$defaults)

  case $installed {
    true: {
      jmeter::package { 'jmeter-packages':
        packages => $packages,
        defaults => $defaults,
      }

      anchor{'jmeter::begin':}         -> Jmeter::Package[jmeter-packages]
      Jmeter::Package[jmeter-packages]  -> anchor{'jmeter::end':}

      motd::register { 'Jmeter' : }

    }
    false: {
      jmeter::package { 'jmeter-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'jmeter-package' |> {
        ensure => 'purged',
      }

      anchor{'jmeter::begin':}         -> Jmeter::Package[jmeter-packages]
      Jmeter::Package[jmeter-packages]  -> anchor{'jmeter::end':}
    }
    # Do Nothing.
    default: {}
  }
}
