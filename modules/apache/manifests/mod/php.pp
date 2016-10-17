# Class: apache::mod::php
#
# This module installs apache phps
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::  Boolean. Whether mod-php is installed or not.
#
# $packages::   The packages to install. This must be an hash of packages.
#
# == Requires:
#
# stdlib, apache::params
#
# == Sample Usage:
#
# include apache::mod::php
# class { 'apache::mod::php' : installed => false }
# class { 'apache::mod::php' :
#   packages => {
#     'mod_php' => {},
#     'mod-php-dev' => {}
#   }
# }
#
class apache::mod::php(
  $installed = true,
  $packages  = hiera('apache_mod_php_packages')
) inherits apache::params {

  include stdlib
  include apache

  validate_bool($installed)
  validate_hash($packages)

  $defaults = {
    'ensure'  => 'latest',
    'require' => 'Class[apache]',
    'notify'  => 'Class[apache::service]',
    'tag'     => 'apache-mod-php',
  }

  create_resources(package, $packages, $defaults)

  case $installed {
    true: {
      Package <| tag == 'apache-mod-php' |> {
        before  => A2mod[php5],
      }
      a2mod { 'php5': ensure => present; }
    }
    false: {
      Package <| tag == 'apache-mod-php' |> {
        ensure  =>  'absent',
      }
    }
    default: {}
  }
}
