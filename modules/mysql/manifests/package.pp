# Define: mysql::package
#
# This module installs mysql packages
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
# stdlib, mysql::params
#
# == Sample Usage:
#
# mysql::package { 'mysql-essentials':
#   packages => hiera('mysql_base_packages')
#   defualts => hiera('mysql_package_defaults')
# }
#
define mysql::package(
  $packages,
  $defaults,
) {

  include stdlib

  validate_hash($packages,$defaults)

  create_resources(package, $packages, $defaults)

}
