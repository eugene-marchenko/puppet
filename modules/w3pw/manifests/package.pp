# Define: w3pw::package
#
# This module installs w3pw packages
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
# stdlib, w3pw::params
#
# == Sample Usage:
#
# w3pw::package { 'w3pw-packages':
#   packages => hiera('w3pw_packages')
#   defualts => hiera('w3pw_package_defaults')
# }
#
define w3pw::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
