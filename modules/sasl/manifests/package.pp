# Define: sasl::package
#
# This module installs sasl packages
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
# stdlib, sasl::params
#
# == Sample Usage:
#
# sasl::package { 'sasl-packages':
#   packages => hiera('sasl_packages')
#   defualts => hiera('sasl_package_defaults')
# }
#
define sasl::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
