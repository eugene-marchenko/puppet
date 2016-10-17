# Class: perl::package::base
#
# This module installs perl packages
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
#               hash. The default is taken from perl::params class.
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
#               'perl_packages'. If you redefine this in a hiera datasource
#               then the key to the files hash must be 'perl_packages', or
#               alternatively, you can change this by passing in the new key
#               with hiera, e.g.
#               class { 'perl::package' : packages => hiera('other_name') }
#
# == Requires:
#
# stdlib, perl::params
#
# == Sample Usage:
#
# include perl::package::base
#
# class { 'perl::package::base' : }
#
# class { 'perl::package::base' : packages => hiera('some_other_packages') }
#
class perl::package::base(
  $defaults = hiera('perl_package_defaults'),
  $packages = hiera('perl_packages'),
  $remove   = false,
) inherits perl::params {

  include stdlib

  validate_bool($remove)
  validate_hash($defaults,$packages)

  create_resources(package, $packages, $defaults)

  if $remove {
    Package <| tag == 'perl-package' |> {
      ensure => absent,
    }
  }

}
