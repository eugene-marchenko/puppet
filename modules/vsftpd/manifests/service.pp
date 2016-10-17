# Class: vsftpd::service
#
# This module installs vsftpd services
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
# stdlib, vsftpd::params
#
# == Sample Usage:
#
# include vsftpd::service
# class { 'vsftpd::service' : installed => false }
#
class vsftpd::service(
  $installed = true,
  $services  = hiera('vsftpd_services'),
) inherits vsftpd::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'vsftpd-service' }

  case $installed {
    true: {
      create_resources(service, $services, $defaults)
    }
    false: {}
    default: {}
  }

}
