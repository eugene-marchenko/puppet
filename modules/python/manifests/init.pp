# Class: python
#
# This module manages python packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the python packages are installed
#                   or not. Valid values are true and false. Defaults to false.
#
# $packages::       An array of packages to install.
#
# $pip_packages::   A hash of pip packages to install. Like the following:
#                   {
#                     'package1' => { 'key1' => 'val1' ... },
#                     ...
#                     'packageN' => { 'key1' => 'val1' ... },
#                   }
#
# == Requires:
#
# stdlib, python::params
#
# == Sample Usage:
#
# include python
#
# class { 'python' : }
#
# class { 'python' : installed => true }
#
# class { 'python' : packages => {
#     'boto' => {
#       'ensure' => 'latest',
#     },
#     'cirrus' => {
#       'ensure' => 'held',
#     },
#   }
# }
#
class python(
  $installed = true,
  $packages  = hiera('python_packages'),
  $defaults  = hiera('python_package_defaults'),
) inherits python::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$defaults)

  case $installed {
    true: {
      class { 'python::package::base':
        packages => $packages,
        defaults => $defaults,
      }
      anchor{'python::begin':}      -> Class[python::package::base]
      Class[python::package::base]  -> anchor{'python::end':}

      motd::register { 'Python' : }

    }
    false: {
      class { 'python::package::base':
        packages => $packages,
        defaults => $defaults,
        remove   => true,
      }
      anchor{'python::begin':}      -> Class[python::package::base]
      Class[python::package::base]  -> anchor{'python::end':}
    }
    # Do Nothing
    default: {}
  }
}
