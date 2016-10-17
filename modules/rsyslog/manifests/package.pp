# Define: rsyslog::package
#
# This module installs rsyslog packages
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
# stdlib, rsyslog::params
#
# == Sample Usage:
#
# rsyslog::package { 'rsyslog-packages':
#   packages => hiera('rsyslog_packages')
#   defualts => hiera('rsyslog_package_defaults')
# }
#
define rsyslog::package(
  $packages,
  $defaults,
) {

  include stdlib

  create_resources(package, $packages, $defaults)
}
