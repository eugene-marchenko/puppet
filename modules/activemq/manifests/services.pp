# Class: activemq::services
#
# This class manages activemq services
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
# stdlib, activemq::params
#
# == Sample Usage:
#
# include activemq::services
# class { 'activemq::services' : enabled => false }
#
# class { 'activemq::services' :
#   services  => hiera('activemq_services')
# }
#
class activemq::services(
  $enabled   = true,
  $running   = true,
  $services  = $activemq::params::services,
  $defaults  = $activemq::params::service_defaults,
) inherits activemq::params {

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

  Service <| tag == 'activemq-service' |> {
    ensure  => $service_ensure,
    enable  => $service_enable
  }
}
