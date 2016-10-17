# Define: dhcp::package
#
# This module installs dhcp packages
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
# stdlib, dhcp::params
#
# == Sample Usage:
#
# dhcp::package { 'dhcp-packages':
#   packages => hiera('dhcp_packages')
#   defualts => hiera('dhcp_package_defaults')
# }
#
define dhcp::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
