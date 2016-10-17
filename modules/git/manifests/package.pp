# Define: git::package
#
# This module installs git packages
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
# stdlib, git::params
#
# == Sample Usage:
#
# git::package { 'git-essentials':
#   packages => hiera('git_base_packages')
#   defualts => hiera('git_package_defaults')
# }
#
define git::package(
  $packages,
  $defaults,
) {

  include stdlib

  validate_hash($packages,$defaults)

  create_resources(package, $packages, $defaults)

}
