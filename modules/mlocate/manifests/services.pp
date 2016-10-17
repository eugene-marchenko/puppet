# Class: mlocate::services
#
# This class manages mlocate services
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $enabled::      Boolean. Whether the service should be enabled.
#
# $service_path:: The filesystem path of the service script.
#
# $service_tmpl:: The path to the service script template.
#
# $servics_tag::  The tag to apply to all of the services resources.
#
# == Requires:
#
# mlocate::params
#
# == Sample Usage:
#
# include mlocate::services
# class { 'mlocate::services' : enabled => false }
#
# class { 'mlocate::services' :
#   service_path  => hiera('mlocate_services')
# }
#
class mlocate::services(
  $enabled      = true,
  $service_path = $mlocate::params::service_path,
  $service_tmpl = $mlocate::params::service_tmpl,
  $service_tag  = $mlocate::params::service_tag,
) inherits mlocate::params {

  File {
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    tag     => $service_tag
  }

  # For some reason tag in resource defaults doesn't work correctly in 2.7.11
  # Add it explicitly to the package resource for now until we can upgrade.
  file { $service_path :
    content => template($service_tmpl),
    tag     => $service_tag,
  }

  case $enabled {
    false: {
      File <| tag == $service_tag |> {
        ensure => 'absent'
      }
    }
    default: {}
  }
}
