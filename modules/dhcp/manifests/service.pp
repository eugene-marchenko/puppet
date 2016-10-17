# Class: dhcp::service
#
# This module installs dhcp services
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
# stdlib, dhcp::params
#
# == Sample Usage:
#
# include dhcp::service
# class { 'dhcp::service' : installed => false }
#
class dhcp::service(
  $installed  = true,
  $services   = hiera('dhcp_services'),
) inherits dhcp::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'dhcp-service' }

  case $installed {
    true: {
      create_resources(exec, $services, $defaults)
    }
    false: {}
    default: {}
  }

}
