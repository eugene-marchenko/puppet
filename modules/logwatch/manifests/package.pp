# Define: logwatch::package
#
# This module installs logwatch packages
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
# stdlib, logwatch::params
#
# == Sample Usage:
#
# logwatch::package { 'logwatch-essentials':
#   packages => hiera('logwatch_base_packages')
#   defualts => hiera('logwatch_package_defaults')
# }
#
define logwatch::package(
  $packages,
  $defaults,
) {

  include stdlib

  validate_hash($packages,$defaults)

  create_resources(package, $packages, $defaults)

}
