# Class: solr
#
# This module manages solr packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the solr packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $solr::params::solr_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $solr::params::solr_package_defaults.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $solr::params::solr_configs.
#
# == Requires:
#
# stdlib, solr::params
#
# == Sample Usage:
#
# include solr
#
# class { 'solr' : }
#
# class { 'solr' : installed => false }
#
# class { 'solr' : packages => hiera('some_other_packages') }
#
class solr(
  $installed      = true,
  $packages       = hiera('solr_packages'),
  $defaults       = hiera('solr_package_defaults'),
  $configs        = hiera('solr_configs'),
) inherits solr::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$configs)

  case $installed {
    true: {
      solr::package { 'solr-packages':
        packages => $packages,
        defaults => $defaults,
      }
      solr::config  { 'solr-configs' :  configs => $configs }

      anchor{'solr::begin':}       -> Solr::Package[solr-packages]
      Solr::Package[solr-packages] -> Solr::Config[solr-configs]
      Solr::Config[solr-configs]   -> anchor{'solr::end':}

      case $::solr_servlet_engine {
        'tomcat': {
          if defined(Class[tomcat::service]) {
            Solr::Config[solr-configs] ~> Class[tomcat::service]
          }
        }
        default: {
          if defined(Class[jetty::service]) {
            Solr::Config[solr-configs] ~> Class[jetty::service]
          }
        }
      }

      motd::register { 'Solr' : }

    }
    false: {
      solr::package { 'solr-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'solr-package' |> {
        ensure => 'purged',
      }

      anchor{'solr::begin':}        -> Solr::Package[solr-packages]
      Solr::Package[solr-packages] -> anchor{'solr::end':}
    }
    # Do Nothing.
    default: {}
  }
}
