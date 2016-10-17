# Define: python::package
#
# This module installs python packages
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $name::       The name of the package to install. This is the name specified
#               when invoking the define. Not a parameter.
#
# $ensure::     The state of the package. Valid values are installed, present,
#               absent, held, purged or the specific package version you want.
#               Note, depending upon the provider, some of these may throw
#               errors. Default is latest.
#
# $provider::   The provider to use. Default is taken from python::params class.
#
# == Requires:
#
# stdlib, python::params
#
# == Sample Usage:
#
# python::package { 'libpython1.8' : }
#
# python::package { [ 'aws-sdk', 'nokogiri', ... ]: provider => 'gem' }
#
define python::package(
  $ensure = 'latest',
  $provider = undef,
) {

  include stdlib
  include python::params
  $defaults = $python::params::python_package_defaults

  if $provider {
    $provider_real = $provider
  } else {
    $provider_real = $defaults[provider]
  }

  package { $name :
    ensure   => $ensure,
    provider => $provider_real,
    tag      => $defaults[tag],
  }

}
