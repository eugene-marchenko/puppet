# Class: ruby
#
# This module manages ruby packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the ruby packages are installed
#                   or not. Valid values are true and false. Defaults to false.
#
# $packages::       An hash of packages to install.
#
#                   {
#                     'package1' => { 'provider' => 'gem', ensure => '0.3'... },
#                     ...
#                     'packageN' => { 'provider' => 'apt' ... },
#                   }
#
# == Requires:
#
# stdlib, ruby::params
#
# == Sample Usage:
#
# include ruby
#
# class { 'ruby' : }
#
# class { 'ruby' : installed => true }
#
# class { 'ruby' : gems => {
#     'aws-sdk'       => {
#       'ensure'    => 'latest',
#       'provider'  => 'gem',
#     },
#     'hiera-puppet'  => {
#       'ensure'    => 'held',
#       'provider'  => 'gem',
#     },
#   }
# }
#
class ruby(
  $installed = true,
  $packages  = $ruby::params::packages,
) inherits ruby::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages)

  if $installed {
    class { 'ruby::package::base' : packages  => $packages }

    anchor { 'ruby::begin': }   -> Class[ruby::package::base]
    Class[ruby::package::base]  -> anchor { 'ruby::end': }

    motd::register { 'Ruby' : }

  }

}
