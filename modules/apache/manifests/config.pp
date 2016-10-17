# Define: apache::config
#
# This module installs apache configs
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
# $defaults::   The config file defaults to use. Default is undef and sane
#               defaults are set inside the define.
#
# == Requires:
#
# stdlib, apache::params
#
# == Sample Usage:
#
# apache::config { 'apache-configs':
#   configs => hiera('apache_configs')
# }
#
define apache::config(
  $configs,
  $defaults = undef,
) {

  include stdlib

  validate_hash($configs)

  if $defaults {
    $defaults_real = $defaults
  } else {
    $defaults_real = { 'tag' => 'apache-config' }
  }

  create_resources(file, $configs, $defaults_real)

}
