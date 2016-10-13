# Class: dhcp
#
# This module manages dhcp packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the dhcp packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $dhcp::params::dhcp_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $dhcp::params::dhcp_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $dhcp::params::dhcp_configs.
#
# == Requires:
#
# stdlib, dhcp::params
#
# == Sample Usage:
#
# include dhcp
#
# class { 'dhcp' : }
#
# class { 'dhcp' : installed => false }
#
# class { 'dhcp' : packages => hiera('some_other_packages') }
#
class dhcp(
  $installed = true,
  $packages  = hiera('dhcp_packages'),
  $defaults  = hiera('dhcp_package_defaults'),
  $configs   = hiera('dhcp_configs'),
) inherits dhcp::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      dhcp::package { 'dhcp-packages':
        packages => $packages,
        defaults => $defaults,
      }
      dhcp::config  { 'dhcp-configs' :  configs => $configs }
      include dhcp::service

      anchor{'dhcp::begin':}        -> Dhcp::Package[dhcp-packages]
      Dhcp::Package[dhcp-packages] -> Dhcp::Config[dhcp-configs]
      Dhcp::Config[dhcp-configs]   -> anchor{'dhcp::end':}

      if defined(Class[dhcp::service]) {
        Dhcp::Config[dhcp-configs]   ~> Class[dhcp::service]
      }

      motd::register { 'Dhcp' : }
    }
    # Currently does nothing. Uninstalling dhcp is probably not a good idea
    # at the moment.
    false: {}
    # Do Nothing.
    default: {}
  }
}
