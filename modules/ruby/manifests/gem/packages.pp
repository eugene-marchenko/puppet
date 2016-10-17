# Class: ruby::gem::packages
#
# This module creates virtual package resources for ruby gem packages that
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
#                   $ruby::params::gem_packages.
#
# == Requires:
#
# stdlib, build::params
#
# == Sample Usage:
#
# include ruby::gem::packages
#
class ruby::gem::packages(
  $packages   = hiera('gem_packages'),
) inherits ruby::params {

  include stdlib

  validate_array($packages)

  @package { $packages: ensure => 'latest', provider => 'gem' }

  motd::register { 'Ruby::Gem::Packages' : }
}
