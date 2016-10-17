# = Class: varnish::params
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
# class varnish::someclass( packages = $varnish::params::some_param
# ) inherits varnish::params {
# ...do something
# }
#
# class { 'varnish::params' : }
#
# include varnish::params
#
class varnish::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports varnish version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    # Set sane defaults if not fact overrides
    if $::varnish_ncsa_pipe_file {
      $varnish_ncsa_pipe_file = $::varnish_ncsa_pipe_file
    } else {
      $varnish_ncsa_pipe_file = '/var/log/varnish/varnishncsa.log'
    }

    # Resource defaults
    $varnish_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'varnish-package',
    }
    $varnish_services = {
      'varnish'     => {
        'ensure'  => 'running',
        'enable'  => true,
      },
    }
    $newrelic_service = {
      'newrelic-varnish' => {
        'ensure'  => 'running',
        'enable'  => true,
      },
    }
    $varnish_log_services = {
      'varnishncsa' => {
          'ensure'  => $varnish_ncsa_log_enabled ? {
            /false|no/  => 'stopped',
            default     => 'running',
          },
          'enable'  => $varnish_ncsa_log_enabled ? {
            /false|no/  => false,
            default     => true,
          },
      },
      'varnishlog'  => {
          'ensure'  => $varnish_log_enabled ? {
            /false|no/  => 'stopped',
            default     => 'running',
          },
          'enable'  => $varnish_log_enabled ? {
            /false|no/  => false,
            default     => true,
          },
      },
    }
    $varnish_packages = {
      'varnish'       => {},
      'libvmod-var'   => {},
      'libvmod-curl'  => {},
    }
    $varnish_vcls = {
      '/etc/varnish/default.vcl'      => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => template('varnish/default.vcl.erb'),
      },
      '/etc/varnish/devicedetect.vcl' => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => template('varnish/devicedetect.vcl.erb')
      },
    }

    $varnish_scripts = {}

    $varnish_configs = {
      '/etc/varnish/secret'           => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
      },
      '/etc/default/varnish'          => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => template('varnish/default/varnish.erb')
      },
      '/etc/varnish/errors'           => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/etc/varnish/errors/500.html'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => template('varnish/errors/500.html.erb')
      },
      '/etc/varnish/errors/404.html'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => template('varnish/errors/404.html.erb')
      },
    }
    $varnish_init_scripts = {
      '/etc/init.d/varnishncsa'       => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'content' => template('varnish/init.d/varnishncsa.erb')
      },
      '/etc/init.d/varnish'        => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'content' => template('varnish/init.d/varnish.erb')
      },
      '/etc/init.d/varnishlog'        => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'content' => template('varnish/init.d/varnishlog.sh.erb')
      },
    }
    $varnish_log_configs = {
      '/etc/default/varnishncsa'      => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => template('varnish/default/varnishncsa.erb')
      },
      '/etc/default/varnishlog'       => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => template('varnish/default/varnishlog.erb')
      },
      '/etc/logrotate.d/varnish'      => {
        'ensure'  => 'absent',
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
