# Class: shells
#
# This module manages shells configs, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the shells configs are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $configs::        The configs to install. Must be a Hash. Defaults to
#                   $shells::params::shells_configs.
#
# == Requires:
#
# stdlib, shells::params
#
# == Sample Usage:
#
# include shells
#
# class { 'shells' : }
#
# class { 'shells' : installed => false }
#
# class { 'shells' : configs => hiera('some_other_configs') }
#
class shells(
  $installed = true,
  $configs   = hiera('shells_configs'),
) inherits shells::params {

  include stdlib

  validate_bool($installed)
  validate_hash($configs)

  case $installed {
    true: {

      shells::config { 'shells-configs':  configs => $configs }

      anchor{'shells::begin':}          -> Shells::Config[shells-configs]
      Shells::Config[shells-configs]    -> anchor{'shells::end':}

      motd::register { 'Shells' : }

    }
    # Currently does nothing. Uninstalling /etc/shells would be bad.
    false: {}
    # Do Nothing.
    default: {}
  }
}
