# Define: logrotate::config
#
# This module installs logrotate configs
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
# stdlib, logrotate::params
#
# == Sample Usage:
#
# logrotate::config { 'logrotate-configs':
#   configs => hiera('logrotate_configs')
# }
#
define logrotate::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'logrotate-config' }

  create_resources(file, $configs, $defaults)

}
