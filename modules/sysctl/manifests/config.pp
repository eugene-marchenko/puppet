# Define: sysctl::config
#
# This module installs sysctl configs
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $configs::      The configs to install. This must be an hash of configs
#
# == Requires:
#
# stdlib, sysctl::params
#
# == Sample Usage:
#
# sysctl::config { 'sysctl-configs':
#   configs => hiera('sysctl_configs')
# }
#
define sysctl::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'sysctl-config' }

  create_resources(file, $configs, $defaults)

}
