# Define: jetty::webapp
#
# This define manages the deployments of jetty webapps.
#
# == Parameters:
#
# == Required:
#
# $config::     The config to drop into /etc/jetty.
#
# $warfile::    The warfile to install.
#
# == Optional:
#
# $installed::  Whether to install the webapp or not. Default is to install.
#
# $enable::     Whether to enable the webapp or not. Default is to enable.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# jetty::webapp { 'jetty-custom-webapp':
#   config  => 'jetty/my-custom-webapp.xml',
#   warfile => 'http://my-location.com/path/to/my-custom-webapp.war',
# }
#
# jetty::webapp { 'jetty-custom-webapp':
#   config  => 'puppet:///modules/jetty/my-custom-webapp.xml',
#   warfile => 'jetty/my-custom-webapp.war',
# }
#
# jetty::webapp { 'jetty-custom-webapp':
#   installed => false,
#   config  => 'puppet:///modules/jetty/my-custom-webapp.xml',
#   warfile => 'jetty/my-custom-webapp.war',
# }
#
# jetty::webapp { 'jetty-custom-webapp':
#   enable  => false,
#   config  => 'puppet:///modules/jetty/my-custom-webapp.xml',
#   warfile => 'jetty/my-custom-webapp.war',
# }
#
define jetty::webapp(
  $config,
  $warfile,
  $installed = false,
  $enable = false,
) {

  include stdlib

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  validate_bool($installed,$enable)

  $cfg_name = basename($config)
  $war_name = basename($warfile)

  $cfg_type = $config ? {
    /puppet:\/\/\// => 'source',
    default         => 'content',
  }

  $cfg = $config ? {
    /http(s)?:\/\// => curl($config),
    /puppet:\/\/\// => $config,
    default         => template($config),
  }

  $war_type = $warfile ? {
    /puppet:\/\/\// => 'source',
    default         => 'content',
  }

  # $war = $warfile ? {
  #   /http(s)?:\/\// => curl($warfile),
  #   /puppet:\/\/\// => $warfile,
  #   default         => template($warfile),
  # }

  case $installed {
    true: {
      case $enable {
        true: {
          case $cfg_type {
            'source': {
              file { "/etc/jetty/${cfg_name}":
                ensure => 'present',
                path   => "/etc/jetty/${cfg_name}",
                source => $cfg,
                tag    => "${name}-webapp",
              }
            }
            default: {
              file { "/etc/jetty/${cfg_name}":
                ensure  => 'present',
                path    => "/etc/jetty/${cfg_name}",
                content => $cfg,
                tag     => "${name}-webapp",
              }
            }
          }
        }
        false: {
          file { "/etc/jetty/${cfg_name}":
            ensure => absent,
            tag    => "${name}-webapp",
          }
        }
        default: {}
      }

      case $war_type {
        'source': {
          file { "/usr/share/jetty/webapps/${war_name}":
            ensure => 'present',
            path   => "/usr/share/jetty/webapps/${war_name}",
            source => $war,
            tag    => "${name}-webapp",
          }
        }
        default: {
          file { "/usr/share/jetty/webapps/${war_name}":
            ensure  => 'present',
            path    => "/usr/share/jetty/webapps/${war_name}",
            content => $war,
            tag     => "${name}-webapp",
          }
        }
      }

      file_line { "/etc/jetty/jetty.conf-${cfg_name}":
        path => '/etc/jetty/jetty.conf',
        line => "/etc/jetty/${cfg_name}",
        tag  => "${name}-webapp",
      }

      if defined(Class[jetty::service]) {
        File <| tag == "${name}-webapp" |> {
          notify  => Class[jetty::service]
        }
      }
    }
    false: {
      file_line { "/etc/jetty/jetty.conf-${cfg_name}":
        path   => '/etc/jetty/jetty.conf',
        line   => "/etc/jetty/${cfg_name}",
        tag    => "${name}-webapp",
        ensure => absent,
      }
      file { "/etc/jetty/${cfg_name}":
        ensure => absent,
        tag    => "${name}-webapp",
      }
      file { "/usr/share/jetty/webapps/${war_name}":
        ensure => absent,
        tag    => "${name}-webapp",
      }

      if defined(Class[jetty::service]) {
        File <| tag == "${name}-webapp" |> {
          notify  => Class[jetty::service]
        }
      }
    }
    default: {}
  }
}
