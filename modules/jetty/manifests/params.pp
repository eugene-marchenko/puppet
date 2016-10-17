# = Class: jetty::params
#
# This module manages default parameters. It does the heavy lifting
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
# class jetty::someclass( packages = $jetty::params::some_param
# ) inherits jetty::params {
# ...do something
# }
#
# class { 'jetty::params' : }
#
# include jetty::params
#
class jetty::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports jetty version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    # Resource Defaults
    include solr::newrelic
    $jetty_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'jetty-package',
    }
    $jetty_services = {
      'jetty' => {
        'ensure'  => 'running',
        'enable'  => true,
      }
    }
    $jetty_packages = {
      'jetty'        => {},
    }
    $jetty_configs = {
      '/etc/default/jetty'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('jetty/Ubuntu/precise/default.erb'),
          default   => template('jetty/Ubuntu/default.erb'),
        }
      },
      # Jetty init script is broken, deploy fixed one.
      '/etc/init.d/jetty'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'require' => 'Class[solr::newrelic]',
        'content' => $::lsbdistcodename ? {
          'precise' => template('jetty/Ubuntu/precise/init.d/jetty.erb'),
          default   => template('jetty/Ubuntu/init.d/jetty.erb'),
        }
      },

      # we need to add a stupid header to make our code not broken, sucks
      '/etc/jetty/jetty.xml' => {
  'ensure' => 'present',
  'owner' => 'root',
  'group' => 'root',
  'mode' => '0644',
  'content' => template('jetty/jetty.xml'),
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
