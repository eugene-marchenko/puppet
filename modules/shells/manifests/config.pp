# Define: shells::config
#
# This module installs shells configs
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
# stdlib, shells::params
#
# == Sample Usage:
#
# shells::config { 'shells-configs':
#   configs => hiera('shells_configs')
# }
#
define shells::config(
  $configs,
) {

  include stdlib

  validate_hash($configs)

  $defaults = { 'tag' => 'shells-config' }

  create_resources(file, $configs, $defaults)

}
