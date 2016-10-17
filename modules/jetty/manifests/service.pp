# Class: jetty::service
#
# This module installs jetty services
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $services::   The services to install. This must be an hash of services
#
# == Requires:
#
# stdlib, jetty::params
#
# == Sample Usage:
#
# include jetty::service
# class { 'jetty::service' : installed  => false }
#
class jetty::service(
  $installed = true,
  $services  = hiera('jetty_services'),
) inherits jetty::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'jetty-service' }

  case $installed {
    true: {
      create_resources(service, $services, $defaults)
    }
    false: {}
    default: {}
  }

}
