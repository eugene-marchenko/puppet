# Class: route53::service
#
# This module registers an instance's fqdn with route53 DNS
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $enable::     Whether to enable the service or not. Defaults to true.
#
# == Required:
#
# stdlib, route53::params
#
# == Sample Usage:
#
# include route53::service
#
# class { 'route53::service' : }
#
# class { 'route53::service' : enable => false }
#
class route53::service(
  $enable = true,
) inherits route53::params {

  include stdlib

  validate_bool($enable)

  $initscript   = $route53::params::initscript
  $service_path = split($initscript, '/')
  $service      = $service_path[-1]

  if $enable {
    exec { 'route53_service' :
      command => "update-rc.d ${service} defaults",
      unless  => "find /etc/rc?.d/???${service} >/dev/null 2>&1"
    }
  } else {
    exec { 'route53_service' :
      command => "update-rc.d -f ${service} remove",
      onlyif  => "find /etc/rc?.d/???${service} >/dev/null 2>&1"
    }
  }
}
