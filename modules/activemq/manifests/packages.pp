# Class: activemq::packages
#
# This class installs activemq packages
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
# stdlib, activemq::params
#
# == Sample Usage:
#
# include activemq::packages
# class { 'activemq::packages' : installed => false }
#
# class { 'activemq::packages' :
#   packages  => hiera('activemq_packages')
# }
#
class activemq::packages(
  $installed = true,
  $packages  = $activemq::params::packages,
  $defaults  = $activemq::params::package_defaults,
) inherits activemq::params {

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
      Package <| tag == 'activemq-package' |> {
        ensure  => 'absent'
      }
    }
    default: {
      fail("Boolean expected for \$installed param: got => ${installed}")
    }
  }
}
