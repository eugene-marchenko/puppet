# Define: monit::package
#
# This module installs monit packages
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
# stdlib, monit::params
#
# == Sample Usage:
#
# monit::package { 'monit-packages':
#   packages => hiera('monit_packages')
#   defualts => hiera('monit_package_defaults')
# }
#
define monit::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
