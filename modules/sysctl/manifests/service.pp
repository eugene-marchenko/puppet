# Class: sysctl::service
#
# This module installs sysctl services
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
# stdlib, sysctl::params
#
# == Sample Usage:
#
# include sysctl::service
# class { 'sysctl::service' : installed => false }
#
class sysctl::service(
  $installed  = true,
  $services   = hiera('sysctl_services'),
) inherits sysctl::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'sysctl-service' }

  case $installed {
    true: {
      create_resources(exec, $services, $defaults)
    }
    false: {}
    default: {}
  }

}
