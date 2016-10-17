# Class: java::packages
#
# This class installs java packages
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
# java::params
#
# == Sample Usage:
#
# include java::packages
# class { 'java::packages' : installed => false, version => '1.2.3' }
#
# class { 'java::packages' :
#   packages  => [ 'java-server', 'java-client' ]
# }
#
class java::packages(
  $installed    = true,
  $version      = 'latest',
  $packages     = $java::params::packages,
  $provider     = $java::params::provider,
  $packages_tag = $java::params::packages_tag,
) inherits java::params {

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
