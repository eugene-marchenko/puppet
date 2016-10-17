# = Class: ssh::package
#
# This module manages the ssh installation package
#
# == Parameters:
#
# === Optional:
#
# $ensure::       This parameter specifies whether ssh should be present or
#                 not. Valid values are present and absent. The default is
#                 present.
#
# $packagename::  This parameter specifies the package name that is searched
#                 for in the package repository. The default is taken from the
#                 ssh::params class.
#
# == Actions:
#
# Ensures the ssh package is either present or not.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# class { 'ssh::package' : ensure => present }
#
# class { 'ssh::package' : ensure => absent }
#
# Override the ssh::params default
#
# class { 'ssh::package' :
#   ensure => present,
#   packagename => "ssh2"
# }
#
class ssh::package(
  $ensure      = present,
  $packages    = $ssh::params::packages,
  $stage       = setup,
) inherits ssh::params {

  validate_array($packages)

  include stdlib

  package { $packages :
    ensure => $ensure,
  }

}
