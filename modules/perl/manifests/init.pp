# Class: perl
#
# This module manages perl packages
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the perl packages are installed
#                   or not. Valid values are true and false. Defaults to false.
#
# $packages::       A hash of packages to install. Like the following:
#                   {
#                     'package1' => { 'key1' => 'val1' ... },
#                     ...
#                     'packageN' => { 'key1' => 'val1' ... },
#                   }
#
# == Requires:
#
# stdlib, perl::params
#
# == Sample Usage:
#
# include perl
#
# class { 'perl' : }
#
# class { 'perl' : installed => true }
#
# class { 'perl' : packages => {
#     'libnet-amazon-ec2-perl' => {
#       'ensure' => 'latest',
#     },
#     'libmailtools-perl' => {
#       'ensure' => 'held',
#     },
#   }
# }
#
class perl(
  $installed = true,
  $packages  = hiera('perl_packages'),
  $defaults  = hiera('perl_package_defaults'),
) inherits perl::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$defaults)

  case $installed {
    true: {
      class { 'perl::package::base':
        packages => $packages,
        defaults => $defaults,
      }
      anchor{'perl::begin':}      -> Class[perl::package::base]
      Class[perl::package::base]  -> anchor{'perl::end':}

      motd::register { 'Perl' : }

    }
    false: {
      class { 'perl::package::base':
        packages => $packages,
        defaults => $defaults,
        remove   => true,
      }
      anchor{'perl::begin':}      -> Class[perl::package::base]
      Class[perl::package::base]  -> anchor{'perl::end':}
    }
    # Do Nothing
    default: {}
  }
}
