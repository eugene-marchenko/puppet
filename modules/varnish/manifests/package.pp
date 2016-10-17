# Define: varnish::package
#
# This module installs varnish packages
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
# stdlib, varnish::params
#
# == Sample Usage:
#
# varnish::package { 'varnish-packages':
#   packages => hiera('varnish_packages')
#   defualts => hiera('varnish_package_defaults')
# }
#
define varnish::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
