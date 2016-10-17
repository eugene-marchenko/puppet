# Define: build::config
#
# This module installs build configs
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
# stdlib, build::params
#
# == Sample Usage:
#
# build::config { 'build-configs':
#   configs => hiera('build_configs')
# }
#
define build::config(
  $configs,
  $defaults = undef,
) {

  include stdlib

  validate_hash($configs)

  if $defaults {
    $defaults_real = $defaults
  } else {
    $defaults_real = { 'tag' => 'build-config' }
  }

  create_resources(file, $configs, $defaults_real)

}
