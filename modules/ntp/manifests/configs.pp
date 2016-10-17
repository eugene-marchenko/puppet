# Class: ntp::configs
#
# This class installs ntp configs
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::  Boolean. Whether the configs are installed or not.
#
# $configs::    The configs to install. This must be an hash of files.
#
# $defaults::   The config file defaults. This must be a hash of parameters.
#
# == Requires:
#
# stdlib, ntp::params
#
# == Sample Usage:
#
# include ntp::configs
# class { 'ntp::configs' : installed => false }
#
# class { 'ntp::configs' :
#   configs  => hiera('ntp_configs')
# }
#
class ntp::configs(
  $installed  = true,
  $configs    = $ntp::params::configs,
  $defaults   = $ntp::params::config_defaults,
) inherits ntp::params {

  include stdlib

  if ! is_hash($configs) {
    fail("Hash expected for \$configs param: got => ${configs}")
  }

  if ! is_hash($defaults) {
    fail("Hash expected for \$defaults param: got => ${defaults}")
  }

  create_resources(file, $configs, $defaults)

  case $installed {
    true: { }
    false: {
      File <| tag == 'ntp-config' |> {
        ensure  => 'absent'
      }
    }
    default: {
      fail("Boolean expected for \$installed param: got => ${installed}")
    }
  }
}
