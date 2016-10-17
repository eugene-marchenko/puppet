# Define: lvm2::package
#
# This module installs lvm2 packages
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
# stdlib, lvm2::params
#
# == Sample Usage:
#
# lvm2::package { 'lvm2-essentials':
#   packages => hiera('lvm2_base_packages')
#   defualts => hiera('lvm2_package_defaults')
# }
#
define lvm2::package(
  $packages,
  $defaults,
) {

  include stdlib

  validate_hash($packages,$defaults)

  create_resources(package, $packages, $defaults)

}
