# = Class: ssh::service
#
# This module manages the ssh service.
#
# == Parameters:
#
# === Optional:
#
# $ensure::       This parameter specifies whether ssh should be running or
#                 not. Valid values are running and stopped. The default is
#                 running.
#
# $enable::       This defines whether the service will be enabled upon boot.
#                 Valid values are true or false. The default is true.
#
# $hasstatus::    This defines whether the service has a status command in the
#                 init script. Valid values are true or false.
#
# $hasrestart::   This defines whether the service has a restart command in the
#                 init script. Valid values are true or false. When false, the
#                 service will be restarted with stop/start.
#
# $status::       This defines the status command for the service if the init
#                 script doesn't have a built-in status command. This command
#                 can be external to the script.
#
# $pattern::      This defines a pattern in the process tree to check for the
#                 service. The default is to check the process tree for the
#                 pattern of the service resource name.
#
# $servicename::  This parameter specifies the service name. The default is
#                 taken from the ssh::params class.
#
# == Actions:
#
# Ensures the ssh configuration file is either running or not.
#
# == Requires:
#
# ssh::package
#
# == Sample Usage:
#
# class { 'ssh::service' : ensure => running, enable => true }
#
# class { 'ssh::service' : ensure => stopped, enable => false }
#
# class { 'ssh::service' :
#   ensure => running,
#   enable => false,
# }
#
# class { 'ssh::service' :
#   ensure => running,
#   enable => true,
#   hasstatus => false,
#   status => "/some/script.sh",
# }
#
# class { 'ssh::service' :
#   ensure => running,
#   enable => true,
#   hasstatus => false,
#   pattern => "ssh-mysql",
# }
#
# class { 'ssh::service' :
#   ensure => running,
#   enable => true,
#   hasrestart => false,
# }
#
# class { 'ssh::service' :
#   ensure      => running,
#   servicename => 'ssh'
# }
#
class ssh::service(
  $ensure      = running,
  $enable      = true,
  $hasstatus   = true,
  $hasrestart  = true,
  $status      = undef,
  $pattern     = undef,
  $servicename = $ssh::params::servicename,
  $stage       = deploy_infra,
) inherits ssh::params {

  include stdlib

  validate_bool($enable,$hasstatus,$hasrestart)

  if $ensure in [ 'running', 'stopped' ] {
    $ensure_real = $ensure
  } else {
    fail('ensure parameter must be running or stopped')
  }

  if ($hasstatus) == true {
    if ($status) {
      fail('hasstatus is true, cannot specify an alternative status command')
    }
    if ($pattern) {
      fail('hasstatus is true, cannot specify a process pattern')
    }
  }

  service { 'ssh' :
    ensure     => $ensure_real,
    enable     => $enable,
    name       => $servicename,
    hasrestart => $hasstatus,
    hasstatus  => $hasrestart,
    status     => $status,
    pattern    => $pattern,
    require    => Class['ssh::package'],
  }
}
