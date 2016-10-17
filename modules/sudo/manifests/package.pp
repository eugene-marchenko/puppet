# = Class: sudo::package
#
# This class ensures the sudoers file
#
# == Parameters:
#
# === Required:
#
# None.
#
# === Optional:
#
# $ensure::       Whether to ensure the sudo package is installed. Defaults to
#                 latest.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# Parameterized class invocation
# class { 'sudo::package' : }
#
# Standard invocation
# include sudo::package
#
# Choose not to ensure the sudo package
# class { 'sudo::package' : ensure => 'absent' }
#
class sudo::package(
  $ensure = 'latest',
  $packagename = hiera('sudo_packagename'),
) inherits sudo::params {

  include stdlib

  package { $packagename :
    ensure => $ensure,
  }

}
