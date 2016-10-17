# Define: apache::package
#
# This module installs apache packages
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $packages::   The packages to install. This must be an hash of packages
#
# $defualts::   The package defaults to use. Must be a hash.
#
# == Requires:
#
# stdlib, apache::params
#
# == Sample Usage:
#
# apache::package { 'apache-packages':
#   packages => hiera('apache_packages')
#   defualts => hiera('apache_package_defaults')
# }
#
define apache::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
