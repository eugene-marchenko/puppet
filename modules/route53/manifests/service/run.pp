# Class: route53::service::run
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
# $run::        Whether to run the service or not. Defaults to true.
#
# == Required:
#
# stdlib, route53::params
#
# == Sample Usage:
#
# include route53::service::run
#
# class { 'route53::service::run' : }
#
# class { 'route53::service::run' : run => false }
#
class route53::service::run(
  $run    = true,
) inherits route53::params {

  include stdlib

  validate_bool($run)

  $hostname     = $route53::params::hostname
  $domain       = $route53::params::domain
  $address      = $route53::params::address
  $type         = $route53::params::type
  $initscript   = $route53::params::initscript

  if $run {
    exec { 'route53_run':
      command => $initscript,
      unless  => "dig +short ${type} ${hostname}.${domain}|grep -q ${address}",
    }
  }
}
