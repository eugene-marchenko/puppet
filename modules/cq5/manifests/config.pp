# Define: cq5::config
#
# This module installs cq5 configs
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
# stdlib, cq5::params
#
# == Sample Usage:
#
# cq5::config { 'cq5-configs':
#   configs => hiera('cq5_configs')
# }
#
define cq5::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'cq5-config' }

  create_resources(file, $configs, $defaults)

}
