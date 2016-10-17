# Class: rsyslog::service
#
# This module installs rsyslog services
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
# stdlib, rsyslog::params
#
# == Sample Usage:
#
# include rsyslog::service
# class { 'rsyslog::service' : installed => false }
#
class rsyslog::service(
  $installed  = true,
  $services   = hiera('rsyslog_services')
) inherits rsyslog::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'rsyslog-service' }

  case $installed {
    true: {
      create_resources(service, $services, $defaults)
    }
    false: {}
    default: {}
  }
}
