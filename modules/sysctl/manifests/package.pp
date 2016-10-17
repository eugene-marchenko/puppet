# Define: sysctl::package
#
# This module installs sysctl packages
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
# stdlib, sysctl::params
#
# == Sample Usage:
#
# sysctl::package { 'sysctl-packages':
#   packages => hiera('sysctl_packages')
#   defualts => hiera('sysctl_package_defaults')
# }
#
define sysctl::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
