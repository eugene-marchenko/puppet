# Class: apache::service
#
# This module installs apache services
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::  Boolean. Whether the service is installed or not.
#
# $services::   The services to install. This must be an hash of services
#
# == Requires:
#
# stdlib, apache::params
#
# == Sample Usage:
#
# include apache::service
# class { 'apache::service' : installed => false }
#
class apache::service(
  $installed = true,
  $services  = hiera('apache_services'),
) inherits apache::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'apache-service' }

  case $installed {
    true: {
      create_resources(service, $services, $defaults)
    }
    false: {}
    default: {}
  }

}
