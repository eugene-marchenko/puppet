# = Class: ssh
#
# This module manages ssh
#
# == Parameters:
#
# === Optional:
#
# $ensure::           This parameter specifies whether ssh should be
#                     installed or not. Valid values are installed and
#                     uninstalled. The default is installed.
#
# $augeas_managed::   This parameter specifies whether augeas will manage the
#                     configuration file. Valid values are true or false. If
#                     true, then the resource Class[ssh::config::default] will
#                     not be present. This is to prevent both augeas and a
#                     template or puppet filebucket managed config file from
#                     overwriting each other.
#
# $packageensure::    This defines the packages state. Valid values are present,
#                     absent, purged, held, latest, or an arbitrary version
#                     string, e.g. 1.0-1. The default is present when
#                     ensure => installed and absent when ensure => uninstalled.
#
# $serviceensure::    This defines the service status. Valid values are running,
#                     stopped. The default is running.
#
# $enable::           This defines whether the service will be enabled upon
#                     boot. Valid values are true or false.
#
# $hasstatus::        This defines whether the service has a status command in
#                     the init script. Valid values are true or false.
#
# $hasrestart::       This defines whether the service has a restart command in
#                     the init script. Valid values are true or false. When
#                     false, the service will be restarted with stop/start.
#
# $status::           This defines the status command for the service if the
#                     init script doesn't have a built-in status command. This
#                     command can be external to the script.
#
# $pattern::          This defines a pattern in the process tree to check for
#                     the service. The default is to check the process tree for
#                     the pattern of the service resource name.
#
# $packages::         This parameter specifies the package names. The default is
#                     taken from the ssh::params class.
#
# $servicename::      This parameter specifies the service name. The default is
#                     taken from the ssh::params class.
#
# $configfiles::      This parameter is a hash. The default is taken from the
#                     ssh::params class.
#
# $configdir::        This parameter specifies the configuration directory. The
#                     default is taken from the ssh::params class.
#
# == Actions:
#
# Ensures ssh is installed or not, the configuration file is present or
# not, and that the ssh service is running or not
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# class { 'ssh': }
#
# class { 'ssh': ensure => installed }
#
# class { 'ssh': ensure => uninstalled }
#
# class { 'ssh': ensure => uninstalled, packageensure => purged, }
#
# class { 'ssh':
#   ensure  => installed,
#   configfiles => {
#     '/etc/ssh/sshd_config'  => {
#       ensure  => present,
#       mode    => '0644',
#       content => template('ssh/sshd_config.erb'),
#       require => Class[ssh::package],
#       notify  => Class[ssh::service],
#     }
#   }
# }
#
class ssh(
  $ensure         = installed,
  $augeas_managed = false,
  $packageensure  = undef,
  $serviceensure  = undef,
  $enable         = true,
  $hasstatus      = true,
  $hasrestart     = true,
  $status         = undef,
  $pattern        = undef,
  $packages       = $ssh::params::packages,
  $servicename    = $ssh::params::servicename,
  $configfiles    = $ssh::params::configfiles,
  $configdir      = $ssh::params::configdir,
) inherits ssh::params {

  validate_bool($augeas_managed)

  if ($ensure == 'installed') {

    # Fine grained control over the package, e.g. 'held', 'latest'
    # Defaults to 'present'
    if ($packageensure) {
      if ($packageensure in [ 'absent', 'purged' ]) {
        fail('packageensure cannot be absent or purged')
      } else {
        $packageensure_real = $packageensure
      }
    } else {
      $packageensure_real = 'present'
    }

    if ($serviceensure) {
      $serviceensure_real = $serviceensure
    } else {
      $serviceensure_real = 'running'
    }

  } elsif ($ensure == 'uninstalled') {

    if ($packageensure) {
      if ($packageensure in [ 'absent', 'purged' ]) {
        $packageensure_real = $packageensure
      } else {
        fail('packageensure must be either absent or purged')
      }
    } else {
      $packageensure_real = 'absent'
    }

  } else {
    fail('ensure must be either installed or uninstalled')
  }

  class { 'ssh::package' :
    ensure   => $packageensure_real,
    packages => $packages,
  }

  if ($ensure == 'installed') {
    if $augeas_managed == false {

      Class['ssh::package'] -> Class['ssh::config::default']
      Class['ssh::config::default'] ~> Class['ssh::service']

      class { 'ssh::config::default' :
        configfiles => $configfiles,
      }

      class { 'ssh::service' :
        ensure      => $serviceensure_real,
        enable      => $enable,
        hasstatus   => $hasstatus,
        hasrestart  => $hasrestart,
        pattern     => $pattern,
        status      => $status,
        servicename => $servicename,
      }
    } else {
      info("augeas_managed is ${augeas_managed}:
          Not managing config through Class[ssh::config::default]")

      class { 'ssh::service' :
        ensure      => $serviceensure_real,
        enable      => $enable,
        hasstatus   => $hasstatus,
        hasrestart  => $hasrestart,
        pattern     => $pattern,
        status      => $status,
        servicename => $servicename,
      }
    }
  } else {
    info('Class[ssh] is uninstalled: not defining Class[ssh::config::default]')
  }
}
