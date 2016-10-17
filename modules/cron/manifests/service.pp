# Class: cron::service
#
# This module installs cron services
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
# stdlib, cron::params
#
# == Sample Usage:
#
# include cron::service
# class { 'cron::service' : installed => false }
#
class cron::service(
  $installed = true,
  $services  = hiera('cron_services'),
) inherits cron::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'cron-service' }

  case $installed {
    true: {
      create_resources(service, $services, $defaults)
    }
    false: {}
    default: {}
  }

}
