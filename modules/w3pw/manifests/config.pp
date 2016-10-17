# Define: w3pw::config
#
# This module installs w3pw configs
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
# stdlib, w3pw::params
#
# == Sample Usage:
#
# w3pw::config { 'w3pw-configs':
#   configs => hiera('w3pw_configs')
# }
#
define w3pw::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'w3pw-config' }

  create_resources(file, $configs, $defaults)

}
