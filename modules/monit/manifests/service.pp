# Class: monit::service
#
# This module installs monit services
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
# stdlib, monit::params
#
# == Sample Usage:
#
# include monit::service
# class { 'monit::service' : installed => false }
#
class monit::service(
  $installed = true,
  $services  = hiera('monit_services'),
) inherits monit::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'monit-service' }

  case $installed {
    true: {
      create_resources(service, $services, $defaults)
    }
    false: {}
    default: {}
  }

}
