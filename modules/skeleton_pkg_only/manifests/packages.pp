# Class: skeleton_pkg_only::packages
#
# This class installs skeleton_pkg_only packages
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
# skeleton_pkg_only::params
#
# == Sample Usage:
#
# include skeleton_pkg_only::packages
# class { 'skeleton_pkg_only::packages' :
#   installed => false,
#   version => '1.2.3'
# }
#
# class { 'skeleton_pkg_only::packages' :
#   packages  => [ 'skeleton_pkg_only-server', 'skeleton_pkg_only-client' ]
# }
#
class skeleton_pkg_only::packages(
  $installed    = true,
  $version      = 'latest',
  $packages     = $skeleton_pkg_only::params::packages,
  $provider     = $skeleton_pkg_only::params::provider,
  $packages_tag = $skeleton_pkg_only::params::packages_tag,
) inherits skeleton_pkg_only::params {

  $defaults = {
    ensure    => $version,
    provider  => $provider,
    tag       => $packages_tag,
  }

  create_resources(package, $packages, $defaults)

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
