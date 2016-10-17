# Class: varnish
#
# This module manages varnish packages, files, scripts and/or services.
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# $installed::      This manages whether the varnish packages are
#                   installed or not. Valid values are true and false. Defaults
#                   to true.
#
# $packages::       The packages to install. Must be a Hash. Defaults to
#                   $varnish::params::varnish_packages.
#
# $defaults::       The package defaults to use. Must be a Hash. Defaults to
#                   $varnish::params::varnish_package_defaults.
#
# $scripts::        Optional varnish scripts to install on the system. Must be
#                   a Hash. Defaults to $varnish::params::varnish_scripts.
#
# $vcl_configs::    The vcl config file(s) to use. Must be a Hash. Defaults
#                   to $varnish::params::varnish_vcls.
#
# $configs::        The config file defaults to use. Must be a Hash. Defaults
#                   to $varnish::params::varnish_configs.
#
# $log_configs::    The config file defaults to use. Must be a Hash. Defaults
#                   to $varnish::params::varnish_log_configs.
#
# == Requires:
#
# stdlib, varnish::params
#
# == Sample Usage:
#
# include varnish
#
# class { 'varnish' : }
#
# class { 'varnish' : installed => false }
#
# class { 'varnish' : packages => hiera('some_other_packages') }
#
class varnish(
  $installed    = true,
  $packages     = hiera('varnish_packages'),
  $defaults     = hiera('varnish_package_defaults'),
  $scripts      = hiera('varnish_scripts'),
  $configs      = hiera('varnish_configs'),
  $vcl_configs  = $varnish::params::varnish_vcls,
  $log_configs  = hiera('varnish_log_configs'),
  $init_scripts  = hiera('varnish_init_scripts'),
) inherits varnish::params {

  include stdlib

  validate_bool($installed)
  validate_hash($packages,$scripts,$vcl_configs,$configs,$log_configs)

  $ncsa_pipe_file = $varnish::params::varnish_ncsa_pipe_file

  case $installed {
    true: {
      varnish::package { 'varnish-packages':
        packages => $packages,
        defaults => $defaults,
      }

      cron::crontab { 'newrelic-varnish-restart' :
        minute  => '00',
        hour    => '13',
        command => '/etc/init.d/newrelic-varnish stop > /dev/null; /etc/init.d/newrelic-varnish start > /dev/null',
      }

      exec { "mkfifo ${ncsa_pipe_file}":
        unless => "test -p ${ncsa_pipe_file}",
      }

      varnish::config  { 'varnish-scripts':       configs => $scripts }
      varnish::config  { 'varnish-vcl-configs':   configs => $vcl_configs }
      varnish::config  { 'varnish-configs':       configs => $configs }
      varnish::config  { 'varnish-log-configs':   configs => $log_configs }
      varnish::config  { 'varnish-init-scripts':  configs => $init_scripts}

      include varnish::newrelic
      include varnish::service
      include varnish::log::service
      include varnish::security

      file {'/usr/local/bin/varnish_restart.py':
          ensure => 'present',
          owner  => 'root',
          group  => 'root',
          mode   => '0700',
          source => 'puppet:///modules/varnish/varnish_restart.py',
      }

      exec { 'varnish-restart':
          command     => '/usr/local/bin/varnish_restart.py -s $(cat /etc/varnish/secret)',
          require     => File['/usr/local/bin/varnish_restart.py'],
          refreshonly => true,
      }

      Varnish::Package[varnish-packages]
      -> Exec["mkfifo ${ncsa_pipe_file}"]
      -> Varnish::Config[varnish-scripts]
      -> Varnish::Config[varnish-vcl-configs]
      -> Varnish::Config[varnish-configs]
      -> Varnish::Config[varnish-init-scripts]
      -> Varnish::Config[varnish-log-configs]
      -> File['/usr/local/bin/varnish_restart.py']

      Varnish::Config[varnish-vcl-configs] ~> Exec[varnish-restart]

      if defined(Class[varnish::service]) {
        Varnish::Config[varnish-configs] ~> Class[varnish::service]
        Varnish::Config[varnish-init-scripts] -> Class[varnish::service]
      }

      if defined(Class[varnish::log::service]) {
        Varnish::Config[varnish-log-configs] ~> Class[varnish::log::service]
      }

      motd::register { 'Varnish' : }

    }
    false: {
      varnish::package { 'varnish-packages':
        packages => $packages,
        defaults => $defaults,
      }

      Package <| tag == 'varnish-package' |> {
        ensure => 'purged',
      }

      anchor{'varnish::begin':}        -> Varnish::Package[varnish-packages]
      Varnish::Package[varnish-packages] -> anchor{'varnish::end':}
    }
    # Do Nothing.
    default: {}
  }
}
