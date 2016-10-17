# Class: python::pip::packages
#
# This module creates virtual package resources for python pip packages that
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
#                   $python::params::pip_packages.
#
# == Requires:
#
# stdlib, build::params
#
# == Sample Usage:
#
# include python::pip::packages
#
class python::pip::packages(
  $packages   = hiera('python_pip_packages'),
) inherits python::params {

  include stdlib

  validate_array($packages)

  @package { $packages: ensure => 'present', provider => 'pip' }

  motd::register { 'Python::Pip::Packages' : }
}
