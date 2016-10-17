# Class: resolver
#
# This module manages resolver configs, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the resolver configs are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $configs::        The configs to install. Must be a Hash. Defaults to
#                   $resolver::params::resolver_configs.
#
# == Requires:
#
# stdlib, resolver::params
#
# == Sample Usage:
#
# include resolver
#
# class { 'resolver' : }
#
# class { 'resolver' : installed => false }
#
# class { 'resolver' : configs => hiera('some_other_configs') }
#
class resolver(
  $installed = true,
  $configs   = hiera('resolver_configs'),
) inherits resolver::params {

  include stdlib

  validate_bool($installed)
  validate_hash($configs)

  case $installed {
    true: {

      resolver::config { 'resolver-configs':  configs => $configs }

      anchor{'resolver::begin':}          -> Resolver::Config[resolver-configs]
      Resolver::Config[resolver-configs]  -> anchor{'resolver::end':}

      motd::register { 'Resolver' : }

    }
    # Currently does nothing. Uninstalling /etc/resolv.conf would be bad.
    false: {}
    # Do Nothing.
    default: {}
  }
}
