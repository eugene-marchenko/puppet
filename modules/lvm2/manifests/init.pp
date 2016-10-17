# Class: lvm2
#
# This module manages lvm2 packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the lvm2 packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $lvm2::params::lvm2_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $lvm2::params::lvm2_package_defaults.
#
# == Requires:
#
# stdlib, lvm2::params
#
# == Sample Usage:
#
# include lvm2
#
# class { 'lvm2' : }
#
# class { 'lvm2' : installed => false }
#
# class { 'lvm2' : packages => hiera('some_other_packages') }
#
class lvm2(
  $installed  = true,
  $packages   = hiera('lvm2_packages'),
  $defaults   = hiera('lvm2_package_defaults'),
) inherits lvm2::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$defaults)

  case $installed {
    true: {
      lvm2::package { 'lvm2-packages':
        packages => $packages,
        defaults => $defaults,
      }

      exec { '/sbin/vgchange -ay' :
        refreshonly => true,
      }

      anchor{'lvm2::begin':}          -> Lvm2::Package[lvm2-packages]
      Lvm2::Package[lvm2-packages]    -> Exec['/sbin/vgchange -ay']
      Exec['/sbin/vgchange -ay']      -> anchor{'lvm2::end':}

      Lvm2::Package[lvm2-packages]    ~> Exec['/sbin/vgchange -ay']

      motd::register { 'Lvm2' : }
    }
    false: {
      lvm2::package { 'lvm2-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'lvm2-package' |> {
        ensure => 'purged',
      }

      anchor{'lvm2::begin':}          -> Lvm2::Package[lvm2-packages]
      Lvm2::Package[lvm2-packages]    -> anchor{'lvm2::end':}
    }
    # Do Nothing.
    default: {}
  }
}
