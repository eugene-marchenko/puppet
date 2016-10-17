# Class: python::package::base
#
# This module installs python packages
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $defaults::   The defaults to set for the package resources. This must be a
#               hash. The default is taken from python::params class.
#
# $packages::   The packages to install. This is required to be a hash with the
#               following strucute:
#               {
#                 'package1' => { 'key1' => 'val1' ... },
#                 ...
#                 'packageN' => { 'key1' => 'val1' ... },
#               }
#
#               The default is taken from hiera with the lookup keyword
#               'python_packages'. If you redefine this in a hiera datasource
#               then the key to the files hash must be 'python_packages', or
#               alternatively, you can change this by passing in the new key
#               with hiera, e.g.
#               class { 'python::package' : packages => hiera('other_name') }
#
# == Requires:
#
# stdlib, python::params
#
# == Sample Usage:
#
# include python::package::base
#
# class { 'python::package::base' : }
#
# class { 'python::package::base' : packages => hiera('some_other_packages') }
#
class python::package::base(
  $defaults = hiera('python_package_defaults'),
  $packages = hiera('python_packages'),
  $remove   = false,
) inherits python::params {

  include stdlib

  validate_bool($remove)
  validate_hash($defaults,$packages)

  create_resources(package, $packages, $defaults)

  if $remove {
    Package <| tag == 'python-package' |> {
      ensure => absent,
    }
  }

}
