# Define: logstash::package
#
# This module installs logstash packages
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
# stdlib, logstash::params
#
# == Sample Usage:
#
# logstash::package { 'logstash-essentials':
#   packages => hiera('logstash_base_packages')
#   defualts => hiera('logstash_package_defaults')
# }
#
define logstash::package(
  $packages,
  $defaults,
) {

  include stdlib

  validate_hash($packages,$defaults)

  create_resources(package, $packages, $defaults)

}
