# Define: ruby::package
#
# This module installs ruby packages
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
# $provider::   The provider to use. Default is taken from ruby::params class.
#
# == Requires:
#
# stdlib, ruby::params
#
# == Sample Usage:
#
# ruby::package { 'libruby1.8' : }
#
# ruby::package { [ 'aws-sdk', 'nokogiri', ... ]: provider => 'gem' }
#
define ruby::package(
  $ensure   = undef,
  $provider = undef,
) {

  include stdlib
  include ruby::params
  $defaults = $ruby::params::defaults

  if $provider {
    $provider_real = $provider
  } else {
    $provider_real = $defaults[provider]
  }

  if $ensure {
    $ensure_real = $ensure
  } else {
    $ensure_real = $defaults[ensure]
  }

  package { $name :
    ensure   => $ensure_real,
    provider => $provider_real,
    tag      => $defaults[tag],
  }

}
