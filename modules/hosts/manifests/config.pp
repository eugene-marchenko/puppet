# Define: hosts::config
#
# This module installs hosts configs
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
# stdlib, hosts::params
#
# == Sample Usage:
#
# hosts::config { 'hosts-configs':
#   configs => hiera('hosts_configs')
# }
#
define hosts::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'hosts-config' }

  create_resources(file, $configs, $defaults)

}
