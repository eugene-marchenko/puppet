# = Class: apache::dispatcher::params
#
# This module manages default dispatcher parameters. It does the heavy lifting
# to determine operating system specific parameters.
#
# == Parameters:
#
# None.
#
# == Actions:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# class apache::someclass( packages = $apache::dispatcher::params::some_param
# ) inherits apache::dispatcher::params {
# ...do something
# }
#
# class { 'apache::dispatcher::params' : }
#
# include apache::dispatcher::params
#
class apache::dispatcher::params {
  include apache::params

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports puppet version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    # Parameter defaults, set sane defaults if no fact overrides
    $apache_dispatcher_root = $::apache_dispatcher_root ? {
      /''|undef/  => '/mnt/dispatcher',
      default     => $::apache_dispatcher_root,
    }

    case $::env {
      /qa|stage/: {
        $apache_dispatcher_version = $::apache_dispatcher_version ? {
          /''|undef/  => '4.1.5',
          default     => $::apache_dispatcher_version,
        }
      }
      default: {
        $apache_dispatcher_version = $::apache_dispatcher_version ? {
          /''|undef/  => '4.1.5',
          default     => $::apache_dispatcher_version,
        }
      }
    }

    $apache_dispatcher_conf = $::apache_dispatcher_conf ? {
      /''|undef/  => '/etc/apache2/dispatcher.any',
      default     => $::apache_dispatcher_conf,
    }

    # Resource defaults
    $apache_dispatcher_configs = {
      "${apache_dispatcher_root}"                     => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/etc/apache2/mods-available/dispatcher.load' => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => template('apache/dispatcher/dispatcher.load.erb')
      },
      '/etc/apache2/mods-available/dispatcher.conf' => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => template('apache/dispatcher/dispatcher.conf.erb')
      },
      '/etc/apache2/ignoreUrlParams.any' => {
        'ensure'  => 'present',
        'content' => template('apache/dispatcher/ignoreUrlParams.any.erb'),
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
      '/usr/lib/apache2/modules/mod_dispatcher.so'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => "puppet:///modules/data/dispatcher/dispatcher-apache2.2-${apache_dispatcher_version}-${::architecture}.so",
      },
      '/var/www/errors'                             => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/var/www/static'                             => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/var/www/errors/404.html'                    => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/data/dispatcher/errors/404.html',
      },
      '/var/www/errors/500.html'                    => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/data/dispatcher/errors/500.html',
      },
      '/var/www/ping.txt'                           => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => 'pong...',
      },
      '/var/www/static/robots.txt'                  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => "puppet:///modules/data/dispatcher/static/robots.txt-${::env}",
      },
      '/var/www/static/apple-touch-icon.png'        => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/data/dispatcher/static/apple-touch-icon.png',
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
