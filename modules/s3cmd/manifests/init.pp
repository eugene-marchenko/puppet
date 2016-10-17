# Class: s3cmd
#
# This module manages s3cmd packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the s3cmd packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $s3cmd::params::s3cmd_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $s3cmd::params::s3cmd_package_defaults.
#
# == Requires:
#
# stdlib, s3cmd::params
#
# == Sample Usage:
#
# include s3cmd
#
# class { 's3cmd' : }
#
# class { 's3cmd' : installed => false }
#
# class { 's3cmd' : packages => hiera('some_other_packages') }
#
class s3cmd(
  $installed  = true,
  $packages   = hiera('s3cmd_packages'),
  $defaults   = hiera('s3cmd_package_defaults'),
) inherits s3cmd::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$defaults)

  case $installed {
    true: {
      s3cmd::package { 's3cmd-packages':
        packages => $packages,
        defaults => $defaults,
      }

      anchor{'s3cmd::begin':}         -> S3cmd::Package[s3cmd-packages]
      S3cmd::Package[s3cmd-packages]  -> anchor{'s3cmd::end':}

      motd::register { 'S3cmd' : }

    }
    false: {
      s3cmd::package { 's3cmd-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 's3cmd-package' |> {
        ensure => 'purged',
      }

      anchor{'s3cmd::begin':}         -> S3cmd::Package[s3cmd-packages]
      S3cmd::Package[s3cmd-packages]  -> anchor{'s3cmd::end':}
    }
    # Do Nothing.
    default: {}
  }
}
