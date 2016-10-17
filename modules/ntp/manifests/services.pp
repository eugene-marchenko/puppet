# Class: ntp::services
#
# This class manages ntp services
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
# $services::   The services to install. This must be a hash of services.
#
# $defaults::   The service defaults. This must be a hash of parameters.
#
# == Requires:
#
# stdlib, ntp::params
#
# == Sample Usage:
#
# include ntp::services
# class { 'ntp::services' : enabled => false }
#
# class { 'ntp::services' :
#   services  => hiera('ntp_services')
# }
#
class ntp::services(
  $enabled   = true,
  $running   = true,
  $services  = $ntp::params::services,
  $defaults  = $ntp::params::service_defaults,
) inherits ntp::params {

  include stdlib

  if ! is_hash($services) {
    fail("Hash expected for \$services param: got => ${services}")
  }

  if ! is_hash($defaults) {
    fail("Hash expected for \$defaults param: got => ${defaults}")
  }

  create_resources(service, $services, $defaults)

  case $enabled {
    true: { $service_enable = true }
    false: { $service_enable = false }
    default: { fail("Boolean expected for \$enabled param: got => ${enabled}") }
  }

  case $running {
    true: { $service_ensure = 'running' }
    false: { $service_ensure = 'stopped' }
    default: { fail("Boolean expected for \$running param: got => ${running}") }
  }

  Service <| tag == 'ntp-service' |> {
    ensure  => $service_ensure,
    enable  => $service_enable
  }
}
