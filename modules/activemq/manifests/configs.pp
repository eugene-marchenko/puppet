# Class: activemq::configs
#
# This class installs activemq configs
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
# stdlib, activemq::params
#
# == Sample Usage:
#
# include activemq::configs
# class { 'activemq::configs' : installed => false }
#
# class { 'activemq::configs' :
#   configs  => hiera('activemq_configs')
# }
#
class activemq::configs(
  $installed  = true,
  $configs    = $activemq::params::configs,
  $defaults   = $activemq::params::config_defaults,
) inherits activemq::params {

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
      File <| tag == 'activemq-config' |> {
        ensure  => 'absent'
      }
    }
    default: {
      fail("Boolean expected for \$installed param: got => ${installed}")
    }
  }
}
