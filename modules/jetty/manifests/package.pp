# Define: jetty::package
#
# This module installs jetty packages
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
# stdlib, jetty::params
#
# == Sample Usage:
#
# jetty::package { 'jetty-packages':
#   packages => hiera('jetty_packages')
#   defualts => hiera('jetty_package_defaults')
# }
#
define jetty::package(
  $packages,
  $defaults,
) {
  include solr::newrelic
  include stdlib

  create_resources(package, $packages, $defaults)
}
