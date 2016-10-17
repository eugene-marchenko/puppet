# Define: resolver::config
#
# This module installs resolver configs
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
# stdlib, resolver::params
#
# == Sample Usage:
#
# resolver::config { 'resolver-configs':
#   configs => hiera('resolver_configs')
# }
#
define resolver::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'resolver-config' }

  create_resources(file, $configs, $defaults)

}
