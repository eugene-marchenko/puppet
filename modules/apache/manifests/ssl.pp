# Class: apache::ssl
#
# This module installs apache ssl
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::  Boolean. Whether ssl and it's related files are installed or not.
#
# == Requires:
#
# stdlib, apache::params
#
# == Sample Usage:
#
# include apache::ssl
# class { 'apache::ssl' : installed => false }
#
class apache::ssl(
  $installed = true,
  $ssl_files = hiera('apache_ssl_files'),
) inherits apache::params {

  include stdlib
  include apache

  validate_bool($installed)
  validate_hash($ssl_files)

  $defaults = {
    'require' => 'Class[apache]',
    'notify'  => 'Class[apache::service]',
    'tag'     => 'apache-ssl-configs',
  }

  case $installed {
    true: {
      A2mod <| title == 'ssl' |> {
        notify  => Class[apache::service]
      }
      apache::config { 'apache-ssl-configs' :
        configs  => $ssl_files,
        defaults => $defaults,
      }
    }
    false: {
      File <| tag == 'apache-ssl-configs' |> {
        ensure  => 'absent',
      }
      A2mod <| title == 'ssl' |> {
        ensure  => 'absent',
      }
    }
    default: {}
  }
}
