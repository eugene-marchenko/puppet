# Define: snmpd::config
#
# This module installs snmpd configs
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
# stdlib, snmpd::params
#
# == Sample Usage:
#
# snmpd::config { 'snmpd-configs':
#   configs => hiera('snmpd_configs')
# }
#
define snmpd::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'snmpd-config' }

  create_resources(file, $configs, $defaults)

}
