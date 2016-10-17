# Define: logrotate::package
#
# This module installs logrotate packages
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
# stdlib, logrotate::params
#
# == Sample Usage:
#
# logrotate::package { 'logrotate-packages':
#   packages => hiera('logrotate_packages')
#   defualts => hiera('logrotate_package_defaults')
# }
#
define logrotate::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
