# Class: sysstat
#
# This module manages sysstat packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the sysstat packages are installed
#                   or not. Valid values are true and false. Defaults to false.
#
# $packages::       The packages to install. Can be a String, Array, or Hash.
#                   If a hash, then $key is used as the hash key.
#
# $packages_key::   The key to look for if $packages is a Hash.
#
# == Requires:
#
# stdlib, sysstat::params
#
# == Sample Usage:
#
# include sysstat
#
# class { 'sysstat' : }
#
# class { 'sysstat' : installed => true }
#
# class { 'sysstat' : packages => [ 'sysstat', ... ] }
#
class sysstat(
  $installed    = true,
  $packages_key = 'packages',
  $packages     = hiera('packages'),
) inherits sysstat::params {

  include stdlib

  validate_bool($installed)

  if $installed {
    class { 'sysstat::packages' : packages => $packages, key => $packages_key }
    anchor { 'sysstat::begin': } -> Class['sysstat::packages']
    Class['sysstat::packages']  -> anchor { 'sysstat::end': }

    motd::register { 'Sysstat' : }

  }

}
