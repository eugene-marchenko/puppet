# Define: sasl::config
#
# This module installs sasl configs
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
# stdlib, sasl::params
#
# == Sample Usage:
#
# sasl::config { 'sasl-configs':
#   configs => hiera('sasl_configs')
# }
#
define sasl::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'sasl-config' }

  create_resources(file, $configs, $defaults)

}
