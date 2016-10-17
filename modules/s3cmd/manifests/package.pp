# Define: s3cmd::package
#
# This module installs s3cmd packages
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
# stdlib, s3cmd::params
#
# == Sample Usage:
#
# s3cmd::package { 's3cmd-essentials':
#   packages => hiera('s3cmd_base_packages')
#   defualts => hiera('s3cmd_package_defaults')
# }
#
define s3cmd::package(
  $packages,
  $defaults,
) {

  include stdlib

  validate_hash($packages,$defaults)

  create_resources(package, $packages, $defaults)

}
