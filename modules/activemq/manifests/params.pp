# = Class: activemq::params
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
# class activemq::someclass( packages = $activemq::params::some_param
# ) inherits activemq::params {
# ...do something
# }
#
# class { 'activemq::params' : }
#
# include activemq::params
#
class activemq::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports activemq version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    # Supported Facts
    $enabled = $::activemq_enabled ? {
      /''|undef/  => 'yes',
      default     => $::activemq_enabled,
    }
    $user = $::activemq_user ? {
      /''|undef/  => 'activemq',
      default     => $::activemq_user,
    }
    $dietime = $::activemq_dietime ? {
      /''|undef/  => undef,
      default     => $::activemq_dietime,
    }
    $starttime = $::activemq_starttime ? {
      /''|undef/  => undef,
      default     => $::activemq_starttime,
    }
    $base  = $::activemq_base ? {
      /''|undef/  => undef,
      default     => $::activemq_base,
    }
    $java_home = $::activemq_java_home ? {
      /''|undef/  => undef,
      default     => $::activemq_java_home,
    }
    $min_heap = $::activemq_min_heap ? {
      /''|undef/  => '512',
      default     => $::activemq_min_heap,
    }
    $max_heap = $::activemq_max_heap ? {
      /''|undef/  => '512',
      default     => $::activemq_max_heap,
    }
    $opts = $::activemq_opts ? {
      /''|undef/  => undef,
      default     => $::activemq_opts,
    }
    $args = $::activemq_args ? {
      /''|undef/  => undef,
      default     => $::activemq_args,
    }

    # Default parameters
    $instance_dir = '/etc/activemq/instances-available'
    $enable_dir = '/etc/activemq/instances-enabled'

    $config_file = $::lsbdistcodename ? {
      'precise' => 'activemq/Ubuntu/precise/activemq.xml.erb',
      default   => 'activemq/Ubuntu/activemq.xml.erb',
    }

    $log4j_properties = $::lsbdistcodename ? {
      'precise' => 'activemq/Ubuntu/precise/log4j.properties.erb',
      default   => 'activemq/Ubuntu/log4j.properties.erb',
    }

    $options_file = $::lsbdistcodename ? {
      'precise' => 'activemq/Ubuntu/precise/options.erb',
      default   => 'activemq/Ubuntu/options.erb',
    }

    # Default package/file/service params
    $package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'activemq-package',
    }
    $packages = {
      'activemq'  => {},
    }
    $config_defaults = {
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'tag'     => 'activemq-config',
    }
    $configs = {
      '/etc/default/activemq'                 => {
        'content' => $::lsbdistcodename ? {
          'precise' => template('activemq/Ubuntu/precise/default.erb'),
          default   => template('activemq/Ubuntu/default.erb'),
        }
      },
      '/usr/share/activemq/activemq-options'  => {
        'content' => $::lsbdistcodename ? {
          'precise' => template('activemq/Ubuntu/precise/options.erb'),
          default   => template('activemq/Ubuntu/options.erb'),
        }
      },
    }
    $service_defaults = {
      'ensure'  => 'running',
      'enable'  => true,
      'tag'     => 'activemq-service',
    }
    $services = {
      'activemq' => {},
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
