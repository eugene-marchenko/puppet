# Define: jetty::config
#
# This module installs jetty configs
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
# stdlib, jetty::params
#
# == Sample Usage:
#
# jetty::config { 'jetty-configs':
#   configs => hiera('jetty_configs')
# }
#
define jetty::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'jetty-config' }

  create_resources(file, $configs, $defaults)

}
