# Class: build
#
# This module manages build packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the build packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $build::params::build_base_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $build::params::build_base_package_defaults.
#
# == Requires:
#
# stdlib, build::params
#
# == Sample Usage:
#
# include build
#
# class { 'build' : }
#
# class { 'build' : installed => false }
#
# class { 'build' : packages => hiera('some_other_packages') }
#
class build(
  $installed  = true,
  $packages   = hiera('build_base_packages'),
  $defaults   = hiera('build_base_package_defaults'),
) inherits build::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$defaults)

  case $installed {
    true: {
      build::package { 'build-packages':
        packages => $packages,
        defaults => $defaults,
      }

      anchor{'build::begin':}         -> Build::Package[build-packages]
      Build::Package[build-packages]  -> anchor{'build::end':}

      motd::register { 'Build' : }
    }
    false: {
      build::package { 'build-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'build-base-package' |> {
        ensure => 'purged',
      }

      anchor{'build::begin':}         -> Build::Package[build-packages]
      Build::Package[build-packages]  -> anchor{'build::end':}
    }
    # Do Nothing.
    default: {}
  }
}
