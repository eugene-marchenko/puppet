# Class: varnish::service
#
# This module installs varnish services
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
# stdlib, varnish::params
#
# == Sample Usage:
#
# include varnish::service
# class { 'varnish::service' : installed => false }
#
class varnish::service(
  $installed = true,
  $services  = hiera('varnish_services'),
) inherits varnish::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'varnish-service' }

  case $installed {
    true: {
      create_resources(service, $services, $defaults)
    }
    false: {}
    default: {}
  }

}
