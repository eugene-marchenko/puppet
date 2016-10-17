# Class: skeleton::packages
#
# This class installs skeleton packages
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
# skeleton::params
#
# == Sample Usage:
#
# include skeleton::packages
# class { 'skeleton::packages' : installed => false, version => '1.2.3' }
#
# class { 'skeleton::packages' :
#   packages  => [ 'skeleton-server', 'skeleton-client' ]
# }
#
class skeleton::packages(
  $installed    = true,
  $version      = 'latest',
  $packages     = $skeleton::params::packages,
  $provider     = $skeleton::params::provider,
  $packages_tag = $skeleton::params::packages_tag,
) inherits skeleton::params {

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
