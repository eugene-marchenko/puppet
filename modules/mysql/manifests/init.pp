# Class: mysql
#
# This module manages mysql packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the mysql packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $mysql::params::mysql_client_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $mysql::params::mysql_package_defaults.
#
# == Requires:
#
# stdlib, mysql::params
#
# == Sample Usage:
#
# include mysql
#
# class { 'mysql' : }
#
# class { 'mysql' : installed => false }
#
# class { 'mysql' : packages => hiera('some_other_packages') }
#
class mysql(
  $installed  = true,
  $packages   = hiera('mysql_client_packages'),
  $defaults   = hiera('mysql_package_defaults'),
) inherits mysql::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$defaults)

  case $installed {
    true: {
      mysql::package { 'mysql-packages':
        packages => $packages,
        defaults => $defaults,
      }

      anchor{'mysql::begin':}         -> Mysql::Package[mysql-packages]
      Mysql::Package[mysql-packages]  -> anchor{'mysql::end':}

      motd::register { 'MySQL' : }
    }
    false: {
      mysql::package { 'mysql-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'mysql-package' |> {
        ensure => 'purged',
      }

      anchor{'mysql::begin':}         -> Mysql::Package[mysql-packages]
      Mysql::Package[mysql-packages]  -> anchor{'mysql::end':}
    }
    # Do Nothing.
    default: {}
  }
}
