# Class: php::packages
#
# This module creates virtual package resources for development packages that
# other classes need to use. It's a central place for defining these packages
# so that other classes can realize them without having to explicitly declare
# a package resource and possibly conflict with another class that declares
# that same package.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $packages::       The packages to install. Must be an array. Defaults to
#                   $php::params::php_packages.
#
# == Requires:
#
# stdlib, php::params
#
# == Sample Usage:
#
# include php::packages
#
class php::packages(
  $packages   = hiera('php_packages'),
) inherits php::params {

  include stdlib

  validate_array($packages)

  @package { $packages: ensure => 'latest', tag => 'php-virtual-package' }

}
