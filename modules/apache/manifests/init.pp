# Class: apache
#
# This module manages apache packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the apache packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $apache::params::apache_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $apache::params::apache_package_defaults.
#
# $modules::        The modules to install. Must be a Hash. Defaults to
#                   $apache::params::apache_modules.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $apache::params::apache_configs.
#
# == Requires:
#
# stdlib, apache::params
#
# == Sample Usage:
#
# include apache
#
# class { 'apache' : }
#
# class { 'apache' : installed => false }
#
# class { 'apache' : packages => hiera('some_other_packages') }
#
class apache(
  $installed = true,
  $packages  = hiera('apache_packages'),
  $defaults  = hiera('apache_package_defaults'),
  $modules   = hiera('apache_modules'),
  $configs   = hiera('apache_configs'),
) inherits apache::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs,$defaults,$modules)

  if has_key($modules, 'items') {
    $mods = $modules[items]
    validate_array($mods)
  } else {
    fail('Could not find key \'items\' in $modules hash')
  }

  case $installed {
    true: {
      apache::package { 'apache-packages':
        packages => $packages,
        defaults => $defaults,
      }
      apache::config  { 'apache-configs' :  configs => $configs }

      # Create virtual resources of all apache modules so other classes 
      # can realize them which avoids the duplicate definition problem.
      @a2mod { $mods :
        ensure  => present,
        require => Apache::Config[apache-configs],
        notify  => Class[apache::service],
        tag     => 'apache-modules',
      }

      include apache::service

      anchor{'apache::begin':}          -> Apache::Package[apache-packages]
      Apache::Package[apache-packages]  -> Apache::Config[apache-configs]
      Apache::Config[apache-configs]    -> anchor{'apache::end':}

      if defined(Class[apache::service]) {
        Apache::Config[apache-configs]   ~> Class[apache::service]
      }

      motd::register { 'Apache' : }
    }
    false: {
      apache::package { 'apache-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'apache-package' |> {
        ensure => 'purged',
      }

      anchor{'apache::begin':}        -> Apache::Package[apache-packages]
      Apache::Package[apache-packages] -> anchor{'apache::end':}
    }
    # Do Nothing.
    default: {}
  }
}
