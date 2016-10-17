# Class: php
#
# This module manages php packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the php packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $base_packages::  The base php packages to install.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $php::params::php_base_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $php::params::php_base_package_defaults.
#
# == Requires:
#
# stdlib, php::params
#
# == Sample Usage:
#
# include php
#
# class { 'php' : }
#
# class { 'php' : installed => false }
#
# class { 'php' : packages => hiera('some_other_packages') }
#
class php(
  $installed  = true,
  $packages   = hiera('php_base_packages'),
  $defaults   = hiera('php_base_package_defaults'),
) inherits php::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$defaults)

  case $installed {
    true: {
      php::base::packages { 'php-base-packages':
        packages => $packages,
        defaults => $defaults,
      }

      include php::packages

      Php::Base::Packages[php-base-packages]
      -> Class[php::packages]

      motd::register { 'Php' : }
    }
    false: {
      php::base::packages { 'php-base-packages':
        packages => $packages,
        defaults => $defaults,
      }

      include php::packages

      Package <| tag == 'php-base-package' |> {
        ensure => 'purged',
      }

      Package <| tag == 'php-virtual-package' |> {
        ensure => 'purged',
      }


      Php::Base::Packages[php-base-packages]
      -> Class[php::packages]
    }
    # Do Nothing.
    default: {}
  }
}
