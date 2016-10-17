# Define: nw_analytics::package
#
# This module installs nw_analytics packages
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
# stdlib, nw_analytics::params
#
# == Sample Usage:
#
# nw_analytics::package { 'nw_analytics-packages':
#   packages => hiera('nw_analytics_packages')
#   defualts => hiera('nw_analytics_package_defaults')
# }
#
define nw_analytics::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
