# Class: ntp::packages
#
# This class installs ntp packages
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::  Boolean. Whether the packages are installed or not.
#
# $packages::   The packages to install. This must be an hash of packages.
#
# $defaults::   The package defaults. This must be a hash of parameters.
#
# == Requires:
#
# stdlib, ntp::params
#
# == Sample Usage:
#
# include ntp::packages
# class { 'ntp::packages' : installed => false }
#
# class { 'ntp::packages' :
#   packages  => hiera('ntp_packages')
# }
#
class ntp::packages(
  $installed = true,
  $packages  = $ntp::params::packages,
  $defaults  = $ntp::params::package_defaults,
) inherits ntp::params {

  include stdlib

  if ! is_hash($packages) {
    fail("Hash expected for \$packages param: got => ${packages}")
  }

  if ! is_hash($defaults) {
    fail("Hash expected for \$defaults param: got => ${defaults}")
  }

  create_resources(package, $packages, $defaults)

  case $installed {
    true: { }
    false: {
      Package <| tag == 'ntp-package' |> {
        ensure  => 'absent'
      }
    }
    default: {
      fail("Boolean expected for \$installed param: got => ${installed}")
    }
  }
}
