# Define: php::base::packages
#
# This module installs php packages
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
# stdlib, php::params
#
# == Sample Usage:
#
# php::base::packages { 'php-essentials':
#   packages => hiera('php_base_packages')
#   defualts => hiera('php_package_defaults')
# }
#
define php::base::packages(
  $packages,
  $defaults,
) {

  include stdlib

  validate_hash($packages,$defaults)

  create_resources(package, $packages, $defaults)

}
