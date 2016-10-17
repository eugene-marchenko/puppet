# Define: build::package
#
# This module installs build packages
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
# stdlib, build::params
#
# == Sample Usage:
#
# build::package { 'build-essentials':
#   packages => hiera('build_base_packages')
#   defualts => hiera('build_package_defaults')
# }
#
define build::package(
  $packages,
  $defaults,
) {

  include stdlib

  validate_hash($packages,$defaults)

  create_resources(package, $packages, $defaults)

}
