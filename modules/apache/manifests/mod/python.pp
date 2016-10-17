# Class: apache::mod::python
#
# This module installs apache pythons
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::  Boolean. Whether the python is installed or not.
#
# $packages::   The packages to install. This must be an hash of packages.
#
# == Requires:
#
# stdlib, apache::params
#
# == Sample Usage:
#
# include apache::mod::python
# class { 'apache::mod::python' : installed => false }
# class { 'apache::mod::python' :
#   packages => {
#     'mod_python' => {},
#     'mod-python-dev' => {}
#   }
# }
#
class apache::mod::python(
  $installed = true,
  $packages  = hiera('apache_mod_python_packages')
) inherits apache::params {

  include stdlib
  include apache

  validate_bool($installed)
  validate_hash($packages)

  $defaults = {
    'ensure'  => 'latest',
    'require' => 'Class[apache]',
    'notify'  => 'Class[apache::service]',
    'tag'     => 'apache-mod-python',
  }

  create_resources(package, $packages, $defaults)

  case $installed {
    true: {
      Package <| tag == 'apache-mod-python' |> {
        before => A2mod[python],
      }
      a2mod { 'python': ensure => present; }
    }
    false: {
      Package <| tag == 'apache-mod-python' |> {
        ensure  =>  'absent',
      }
    }
    default: {}
  }
}
