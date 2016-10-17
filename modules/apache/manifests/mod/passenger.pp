# Class: apache::mod::passenger
#
# This module installs apache passengers
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::  Boolean. Whether the passenger is installed or not.
#
# $packages::   The packages to install. This must be an hash of packages.
#
# == Requires:
#
# stdlib, apache::params
#
# == Sample Usage:
#
# include apache::mod::passenger
# class { 'apache::mod::passenger' : installed => false }
# class { 'apache::mod::passenger' :
#   packages => {
#     'mod_passenger' => {},
#     'mod-passenger-dev' => {}
#   }
# }
#
class apache::mod::passenger(
  $installed = true,
  $packages  = hiera('apache_mod_passenger_packages')
) inherits apache::params {

  include stdlib
  include apache

  validate_bool($installed)
  validate_hash($packages)

  $defaults = {
    'ensure'  => 'latest',
    'require' => 'Class[apache]',
    'notify'  => 'Class[apache::service]',
    'tag'     => 'apache-mod-passenger',
  }

  create_resources(package, $packages, $defaults)

  case $installed {
    true: {
      Package <| tag == 'apache-mod-passenger' |> {
        before  => A2mod[passenger],
      }
      a2mod { 'passenger': ensure => present; }
    }
    false: {
      Package <| tag == 'apache-mod-passenger' |> {
        ensure  =>  'absent',
      }
    }
    default: {}
  }
}
