# Class: postfix::service
#
# This module installs postfix services
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
# stdlib, postfix::params
#
# == Sample Usage:
#
# include postfix::service
# class { 'postfix::service' : installed => false }
#
class postfix::service(
  $installed = true,
  $services  = hiera('postfix_services'),
) inherits postfix::params {

  include stdlib

  validate_hash($services)

  $defaults = { 'tag' => 'postfix-service' }

  case $installed {
    true: {
      create_resources(service, $services, $defaults)
    }
    false: {}
    default: {}
  }

}
