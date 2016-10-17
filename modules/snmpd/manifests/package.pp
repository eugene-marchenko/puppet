# Define: snmpd::package
#
# This module installs snmpd packages
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
# stdlib, snmpd::params
#
# == Sample Usage:
#
# snmpd::package { 'snmpd-packages':
#   packages => hiera('snmpd_packages')
#   defualts => hiera('snmpd_package_defaults')
# }
#
define snmpd::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
