# Define: dhcp::config
#
# This module installs dhcp configs
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
# stdlib, dhcp::params
#
# == Sample Usage:
#
# dhcp::config { 'dhcp-configs':
#   configs => hiera('dhcp_configs')
# }
#
define dhcp::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'dhcp-config' }

  create_resources(file_line, $configs, $defaults)

}
