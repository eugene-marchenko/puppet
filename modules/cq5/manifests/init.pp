# Class: cq5
#
# This module manages cq5 packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the cq5 packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $cq5::params::cq5_configs.
#
# == Requires:
#
# stdlib, cq5::params
#
# == Sample Usage:
#
# include cq5
#
# class { 'cq5' : }
#
# class { 'cq5' : installed => false }
#
# class { 'cq5' : configs => hiera('some_other_configs') }
#
class cq5(
  $installed = true,
  $configs   = hiera('cq5_configs'),
) inherits cq5::params {

  include stdlib

  validate_bool($installed)
  validate_hash($configs)

  case $installed {
    true: {
      cq5::config  { 'cq5-configs' :  configs => $configs }

      anchor{'cq5::begin':}      -> Cq5::Config[cq5-configs]
      Cq5::Config[cq5-configs]   -> anchor{'cq5::end':}

      motd::register { 'Cq5' : }
    }
    false: {
      cq5::config  { 'cq5-configs' :  configs => $configs }

      File <| tag == 'cq5-config' |> {
        ensure => 'absent',
      }

      anchor{'cq5::begin':}     -> Cq5::Config[cq5-configs]
      Cq5::Config[cq5-configs]  -> anchor{'cq5::end':}
    }
    # Do Nothing.
    default: {}
  }
}
