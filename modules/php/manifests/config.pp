# Define: php::config
#
# This module installs php configs
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $configs::    The configs to install. This must be an hash of configs
#
# $defaults::   The config file defaults to use. Default is undef and sane
#               defaults are set inside the define.
#
# == Requires:
#
# stdlib, php::params
#
# == Sample Usage:
#
# php::config { '/etc/php5/cli/conf.d/foo.ini':
#   content => "foo = 10\n",
# }
#
define php::config(
  $ensure   = 'present',
  $content  = '',
  $template = '',
  $source   = '',
) {

  include stdlib
  include php

  case $ensure {
    'present', 'absent': { $ensure_real = $ensure }
    default: { fail('Invalid ensure, Valid values are present or absent') }
  }

  case $template {
    '': {
      case $content {
        '': {
          case $source {
            '': { fail('No template, content or source specified') }
            default: { File{ source => $source} }
          }
        }
        default: { File{ content => $content} }
      }
    }
    default: { File{ content => template($template)} }
  }

  file { $name :
    ensure => $ensure_real,
    path   => $name,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

}
