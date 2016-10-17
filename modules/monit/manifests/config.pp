# Define: monit::config
#
# This module installs monit configs
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
# stdlib, monit::params
#
# == Sample Usage:
#
# monit::config { 'monit-configs':
#   configs => hiera('monit_configs')
# }
#
define monit::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'monit-config' }

  create_resources(file, $configs, $defaults)

}
