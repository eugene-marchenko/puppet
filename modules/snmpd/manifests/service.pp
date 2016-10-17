# Class: snmpd::service
#
# This module installs snmpd services
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
# stdlib, snmpd::params
#
# == Sample Usage:
#
# include snmpd::service
# class { 'snmpd::service' : installed => false }
#
class snmpd::service(
  $installed = true,
  $services  = hiera('snmpd_services'),
) inherits snmpd::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'snmpd-service' }

  case $installed {
    true: {
      create_resources(service, $services, $defaults)
    }
    false: {}
    default: {}
  }

}
