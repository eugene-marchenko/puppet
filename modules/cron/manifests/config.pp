# Define: cron::config
#
# This module installs cron configs
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
# stdlib, cron::params
#
# == Sample Usage:
#
# cron::config { 'cron-configs':
#   configs => hiera('cron_configs')
# }
#
define cron::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'cron-config' }

  create_resources(file, $configs, $defaults)

}
