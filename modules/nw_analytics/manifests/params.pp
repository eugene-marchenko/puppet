# = Class: nw_analytics::params
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
# class nw_analytics::someclass( packages = $nw_analytics::params::some_param
# ) inherits nw_analytics::params {
# ...do something
# }
#
# class { 'nw_analytics::params' : }
#
# include nw_analytics::params
#
class nw_analytics::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports nw_analytics version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    $nw_analytics_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'nw_analytics-package',
    }
    $nw_analytics_packages = {
      'nw-analytics'        => {},
    }
    $nw_analytics_configs = {
      '/etc/nw-analytics/nwdb-analytics.properties'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'content' => $::lsbdistcodename ? {
          'precise' => template('nw_analytics/Ubuntu/precise/nwdb-analytics.properties.erb'),
          default   => template('nw_analytics/Ubuntu/nwdb-analytics.properties.erb'),
        }
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
