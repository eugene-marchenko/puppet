# Define: varnish::config
#
# This module installs varnish configs
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
# stdlib, varnish::params
#
# == Sample Usage:
#
# varnish::config { 'varnish-configs':
#   configs => hiera('varnish_configs')
# }
#
define varnish::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'varnish-config' }

  create_resources(file, $configs, $defaults)

}
