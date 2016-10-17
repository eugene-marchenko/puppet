# Class: vsftpd
#
# This module manages vsftpd packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the vsftpd packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $vsftpd::params::vsftpd_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $vsftpd::params::vsftpd_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $vsftpd::params::vsftpd_configs.
#
# == Requires:
#
# stdlib, vsftpd::params
#
# == Sample Usage:
#
# include vsftpd
#
# class { 'vsftpd' : }
#
# class { 'vsftpd' : installed => false }
#
# class { 'vsftpd' : packages => hiera('some_other_packages') }
#
class vsftpd(
  $installed = true,
  $packages  = hiera('vsftpd_packages'),
  $defaults  = hiera('vsftpd_package_defaults'),
  $configs   = hiera('vsftpd_configs'),
) inherits vsftpd::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      vsftpd::package { 'vsftpd-packages':
        packages => $packages,
        defaults => $defaults,
      }
      vsftpd::config  { 'vsftpd-configs' :  configs => $configs }
      include vsftpd::service

      anchor{'vsftpd::begin':}        -> Vsftpd::Package[vsftpd-packages]
      Vsftpd::Package[vsftpd-packages] -> Vsftpd::Config[vsftpd-configs]
      Vsftpd::Config[vsftpd-configs]   -> anchor{'vsftpd::end':}

      if defined(Class[vsftpd::service]) {
        Vsftpd::Config[vsftpd-configs]   ~> Class[vsftpd::service]
      }

      motd::register { 'Vsftpd' : }

    }
    false: {
      vsftpd::package { 'vsftpd-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'vsftpd-package' |> {
        ensure => 'purged',
      }

      anchor{'vsftpd::begin':}        -> Vsftpd::Package[vsftpd-packages]
      Vsftpd::Package[vsftpd-packages] -> anchor{'vsftpd::end':}
    }
    # Do Nothing.
    default: {}
  }
}
