# Class: build::devtools
#
# This module manages build devtools packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the build packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# == Requires:
#
# stdlib, build::params
#
# == Sample Usage:
#
# include build::devtools
#
# class { 'build::devtools' : }
#
# class { 'build::devtools' : installed => false }
#
class build::devtools(
  $installed  = true,
  $configs    = hiera('build_devtools_configs'),
) inherits build::params {

  include stdlib
  include build::devlibs

  validate_bool($installed)
  validate_hash($configs)

  case $installed {
    true: {
      Package <| tag == 'devlib-packages' |> {
        ensure  => 'latest',
      }

      build::config { 'build-devtool-configs' :
        configs => $configs,
      }

      motd::register { 'Build::Devtools' : }
    }
    false: {
      Package <| tag == 'devlib-packages' |> {
        ensure => 'purged',
      }
    }
    # Do Nothing.
    default: {}
  }
}
