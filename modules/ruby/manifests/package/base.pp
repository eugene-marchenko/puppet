# Class: ruby::package::base
#
# This module installs ruby packages
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
#               hash. The default is taken from ruby::params class.
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
#               'packages'. If you redefine this in a hiera datasource
#               then the key to the files hash must be 'packages', or
#               alternatively, you can change this by passing in the new key
#               with hiera, e.g.
#               class { 'ruby::package' : packages => hiera('other_name') }
#
# == Requires:
#
# stdlib, ruby::params
#
# == Sample Usage:
#
# include ruby::package::base
#
# class { 'ruby::package::base' : }
#
# class { 'ruby::package::base' : packages => hiera('some_other_packages') }
#
class ruby::package::base(
  $defaults = $ruby::params::defaults,
  $packages = hiera('packages'),
) inherits ruby::params {

  include stdlib

  validate_hash($defaults,$packages)

  create_resources(package, $packages, $defaults)

}
