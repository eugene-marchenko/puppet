# Class: git
#
# This module manages git packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the git packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $git::params::git_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $git::params::git_package_defaults.
#
# == Requires:
#
# stdlib, git::params
#
# == Sample Usage:
#
# include git
#
# class { 'git' : }
#
# class { 'git' : installed => false }
#
# class { 'git' : packages => hiera('some_other_packages') }
#
class git(
  $installed  = true,
  $packages   = hiera('git_packages'),
  $defaults   = hiera('git_package_defaults'),
) inherits git::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$defaults)

  case $installed {
    true: {
      git::package { 'git-packages':
        packages => $packages,
        defaults => $defaults,
      }

      anchor{'git::begin':}         -> Git::Package[git-packages]
      Git::Package[git-packages]  -> anchor{'git::end':}

      motd::register { 'Git' : }

    }
    false: {
      git::package { 'git-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'git-package' |> {
        ensure => 'purged',
      }

      anchor{'git::begin':}         -> Git::Package[git-packages]
      Git::Package[git-packages]  -> anchor{'git::end':}
    }
    # Do Nothing.
    default: {}
  }
}
