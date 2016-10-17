# Define: cron::package
#
# This module installs cron packages
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
# stdlib, cron::params
#
# == Sample Usage:
#
# cron::package { 'cron-packages':
#   packages => hiera('cron_packages')
#   defualts => hiera('cron_package_defaults')
# }
#
define cron::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
