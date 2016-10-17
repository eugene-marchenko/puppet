# Class: build::devlibs
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
#                   $build::params::build_devlibs_packages.
#
# == Requires:
#
# stdlib, build::params
#
# == Sample Usage:
#
# include build::devlibs
#
class build::devlibs(
  $packages   = hiera('build_devlibs_packages'),
) inherits build::params {

  include stdlib

  validate_array($packages)

  @package { $packages: ensure => 'latest', tag => 'devlib-packages' }

  motd::register { 'Build::Devlibs' : }
}
