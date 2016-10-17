# Define: vsftpd::package
#
# This module installs vsftpd packages
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
# stdlib, vsftpd::params
#
# == Sample Usage:
#
# vsftpd::package { 'vsftpd-packages':
#   packages => hiera('vsftpd_packages')
#   defualts => hiera('vsftpd_package_defaults')
# }
#
define vsftpd::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
