# Class: rsyslog
#
# This module manages rsyslog packages, files, scripts.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the rsyslog packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $rsyslog::params::rsyslog_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $rsyslog::params::rsyslog_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $rsyslog::params::rsyslog_configs.
#
# == Requires:
#
# stdlib, rsyslog::params
#
# == Sample Usage:
#
# include rsyslog
#
# class { 'rsyslog' : }
#
# class { 'rsyslog' : installed => false }
#
# class { 'rsyslog' : packages => hiera('some_other_packages') }
#
class rsyslog(
  $installed = true,
  $packages  = hiera('rsyslog_packages'),
  $defaults  = hiera('rsyslog_package_defaults'),
  $configs   = hiera('rsyslog_configs'),
) inherits rsyslog::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      rsyslog::package { 'rsyslog-packages':
        packages => $packages,
        defaults => $defaults,
      }
      rsyslog::config  { 'rsyslog-configs' :  configs => $configs }
      include rsyslog::service

      anchor{'rsyslog::begin':}          -> Rsyslog::Package[rsyslog-packages]
      Rsyslog::Package[rsyslog-packages] -> Rsyslog::Config[rsyslog-configs]
      Rsyslog::Config[rsyslog-configs]   -> anchor{'rsyslog::end':}

      if defined(Class[rsyslog::service]) {
        Rsyslog::Config[rsyslog-configs] ~> Class[rsyslog::service]
      }

      motd::register { 'Rsyslog' : }

    }
    false: {
      rsyslog::package { 'rsyslog-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'rsyslog-package' |> {
        ensure => 'purged',
      }

      anchor{'rsyslog::begin':}        -> Rsyslog::Package[rsyslog-packages]
      Rsyslog::Package[rsyslog-packages] -> anchor{'rsyslog::end':}
    }
    # Do Nothing.
    default: {}
  }
}
