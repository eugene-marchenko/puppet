# Define: postfix::config
#
# This module installs postfix configs
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
# stdlib, postfix::params
#
# == Sample Usage:
#
# postfix::config { 'postfix-configs':
#   configs => hiera('postfix_configs')
# }
#
define postfix::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'postfix-config' }

  create_resources(file, $configs, $defaults)

}
