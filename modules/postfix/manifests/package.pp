# Define: postfix::package
#
# This module installs postfix packages
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
# stdlib, postfix::params
#
# == Sample Usage:
#
# postfix::package { 'postfix-packages':
#   packages => hiera('postfix_packages')
#   defualts => hiera('postfix_package_defaults')
# }
#
define postfix::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
