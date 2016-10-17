# Define: jmeter::package
#
# This module installs jmeter packages
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
# stdlib, jmeter::params
#
# == Sample Usage:
#
# jmeter::package { 'jmeter-essentials':
#   packages => hiera('jmeter_base_packages')
#   defualts => hiera('jmeter_package_defaults')
# }
#
define jmeter::package(
  $packages,
  $defaults,
) {

  include stdlib

  validate_hash($packages,$defaults)

  create_resources(package, $packages, $defaults)

}
