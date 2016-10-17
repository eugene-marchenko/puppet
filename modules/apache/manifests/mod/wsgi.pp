# Class: apache::mod::wsgi
#
# This module installs apache wsgis
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::  Boolean. Whether mod-wsgi is installed or not.
#
# $packages::   The packages to install. This must be an hash of packages.
#
# == Requires:
#
# stdlib, apache::params
#
# == Sample Usage:
#
# include apache::mod::wsgi
# class { 'apache::mod::wsgi' : installed => false }
# class { 'apache::mod::wsgi' :
#   packages => {
#     'mod_wsgi' => {},
#     'mod-wsgi-dev' => {}
#   }
# }
#
class apache::mod::wsgi(
  $installed = true,
  $packages  = hiera('apache_mod_wsgi_packages')
) inherits apache::params {

  include stdlib
  include apache

  validate_bool($installed)
  validate_hash($packages)

  $defaults = {
    'ensure'  => 'latest',
    'require' => 'Class[apache]',
    'notify'  => 'Class[apache::service]',
    'tag'     => 'apache-mod-wsgi',
  }

  create_resources(package, $packages, $defaults)

  case $installed {
    true: {
      Package <| tag == 'apache-mod-wsgi' |> {
        before  => A2mod[wsgi],
      }
      a2mod { 'wsgi': ensure => present; }
    }
    false: {
      Package <| tag == 'apache-mod-wsgi' |> {
        ensure  =>  'absent',
      }
    }
    default: {}
  }
}
