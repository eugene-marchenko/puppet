# Class: skeleton::services
#
# This class manages skeleton services
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $enabled::      Boolean. Whether the service should be enabled at boot.
#
# $running::      Boolean. Whether the service should be running.
#
# $services::     The services to install. This must be a Array of services.
#
# $servics_tag::  The tag to apply to all of the services resources.
#
# == Requires:
#
# skeleton::params
#
# == Sample Usage:
#
# include skeleton::services
# class { 'skeleton::services' : enabled => false }
#
# class { 'skeleton::services' :
#   services  => hiera('skeleton_services')
# }
#
class skeleton::services(
  $enabled      = true,
  $running      = 'running',
  $services     = $skeleton::params::services,
  $services_tag = $skeleton::params::services_tag
) inherits skeleton::params {

  Service {
    tag => $services_tag
  }

  # For some reason tag in resource defaults doesn't work correctly in 2.7.11
  # Add it explicitly to the package resource for now until we can upgrade.
  service { $services :
    ensure => $running,
    enable => $enabled,
    tag    => $services_tag,
  }
}
