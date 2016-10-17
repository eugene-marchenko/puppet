# Class: mlocate::packages
#
# This class installs mlocate packages
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::    Boolean. Whether the packages are installed or not.
#
# $version::      The version of the package. Defaults to 'latest'.
#
# $packages::     The packages to install. This must be an Array of packages.
#
# $provider::     The package provider. Distro dependent.
#
# $packages_tag:: The tag to apply to all of the package resources.
#
# == Requires:
#
# mlocate::params
#
# == Sample Usage:
#
# include mlocate::packages
# class { 'mlocate::packages' : installed => false, version => '1.2.3' }
#
# class { 'mlocate::packages' :
#   packages  => [ 'mlocate-server', 'mlocate-client' ]
# }
#
class mlocate::packages(
  $installed    = true,
  $version      = 'latest',
  $packages     = $mlocate::params::packages,
  $provider     = $mlocate::params::provider,
  $packages_tag = $mlocate::params::packages_tag,
) inherits mlocate::params {

  Package {
    provider  => $provider,
    tag       => $packages_tag,
  }

  # For some reason tag in resource defaults doesn't work correctly in 2.7.11
  # Add it explicitly to the package resource for now until we can upgrade.
  package { $packages : ensure => $version, tag => $packages_tag }

  case $installed {
    true: {}
    false: {
      Package <| tag == $packages_tag |> {
        ensure  => 'absent',
      }
    }
    default: {
      fail("Boolean expected for \$installed param: got => ${installed}")
    }
  }
}
