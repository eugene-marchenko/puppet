# Define: perl::package
#
# This module installs perl packages
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
# $provider::   The provider to use. Default is taken from perl::params class.
#
# == Requires:
#
# stdlib, perl::params
#
# == Sample Usage:
#
# perl::package { 'libperl1.8' : }
#
# perl::package { [ 'libnet-amazon-ec2-perl', 'perl-doc', ... ]:
#   ensure => 'held',
# }
#
define perl::package(
  $ensure = 'latest',
  $provider = undef,
) {

  include stdlib
  include perl::params
  $defaults = $perl::params::perl_package_defaults

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
