# Class: sasl::service
#
# This module installs sasl services
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
# stdlib, sasl::params
#
# == Sample Usage:
#
# include sasl::service
# class { 'sasl::service' : installed => false }
#
class sasl::service(
  $installed = true,
  $services  = hiera('sasl_services'),
) inherits sasl::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'sasl-service' }

  case $installed {
    true: {
      create_resources(service, $services, $defaults)
    }
    false: {}
    default: {}
  }

}
