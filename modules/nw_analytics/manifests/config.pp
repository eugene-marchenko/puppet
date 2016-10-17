# Define: nw_analytics::config
#
# This module installs nw_analytics configs
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $configs::    The configs to install. This must be an hash of configs
#
# == Requires:
#
# stdlib, nw_analytics::params
#
# == Sample Usage:
#
# nw_analytics::config { 'nw_analytics-configs':
#   configs => hiera('nw_analytics_configs')
# }
#
define nw_analytics::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'nw_analytics-config' }

  create_resources(file, $configs, $defaults)

}
