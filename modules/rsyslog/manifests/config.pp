# Define: rsyslog::config
#
# This module installs rsyslog configs
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
# stdlib, rsyslog::params
#
# == Sample Usage:
#
# rsyslog::config { 'rsyslog-configs':
#   configs => hiera('rsyslog_configs')
# }
#
define rsyslog::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'rsyslog-config' }

  create_resources(file, $configs, $defaults)

}
