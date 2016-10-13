# Class: hosts
#
# This module manages hosts configs, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the hosts configs are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $configs::        The configs to install. Must be a Hash. Defaults to
#                   $hosts::params::hosts_configs.
#
# == Requires:
#
# stdlib, hosts::params
#
# == Sample Usage:
#
# include hosts
#
# class { 'hosts' : }
#
# class { 'hosts' : installed => false }
#
# class { 'hosts' : configs => hiera('some_other_configs') }
#
class hosts(
  $installed = true,
  $configs   = hiera('hosts_configs'),
) inherits hosts::params {

  include stdlib

  validate_bool($installed)
  validate_hash($configs)

  case $installed {
    true: {
      hosts::config  { 'hosts-configs' :  configs => $configs }

      anchor{'hosts::begin':}       -> Hosts::Config[hosts-configs]
      Hosts::Config[hosts-configs]  -> anchor{'hosts::end':}

      motd::register { 'Hosts' : }

    }
    # Do Nothing. hosts is a core service.
    false: { }
    # Do Nothing.
    default: {}
  }
}
