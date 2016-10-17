# = Class: ssh::config::default
#
# This module manages the ssh configuration file.
#
# == Parameters:
#
# === Optional:
#
# $configfiles::  This parameter specifies the server config file name. The
#                 default is taken from the ssh::params class.
#
# $configdir::    This parameter specifies the configuration directory. The
#                 default is taken from the ssh::params class.
#
# == Actions:
#
# Ensures the creation of default file resources.
#
# == Requires:
#
# ssh::params, ssh::config::file
#
# == Sample Usage:
#
# class { ssh::config::default : }
#
# Override the ssh::params default
#
# class { ssh::config::default :
#   configfiles => {
#     '/etc/ssh/sshd_config' => {
#       ensure  => 'present',
#       path    => '/etc/ssh/sshd_config2',
#       mode    => '0644',
#       owner   => 'root',
#       group   => 'root',
#       require => Class[ssh::package],
#       notify  => Class[ssh::service],
#     },
#     '/etc/ssh/ssh_config' => {
#       ensure  => 'present',
#       path    => '/etc/ssh/ssh_config2',
#       mode    => '0644',
#       owner   => 'root',
#       group   => 'root',
#       require => Class[ssh::package],
#     },
#     '/etc/default/ssh' => {
#       ensure  => 'present',
#       path    => '/etc/default/ssh2',
#       mode    => '0644',
#       owner   => 'root',
#       group   => 'root',
#       require => Class[ssh::package],
#       notify  => Class[ssh::service],
#     },
#   },
# }
#
# Manage config from filebucket or template
#
# class { ssh::config::default :
#   configfiles => {
#     '/etc/ssh/sshd_config' => {
#       ensure  => 'present',
#       content => template('ssh/sshd_config.erb'),
#       mode    => '0644',
#       require => Class[ssh::package],
#       notify  => Class[ssh::service],
#     },
#   },
# }
# class { ssh::config::default :
#   configfiles => {
#     '/etc/ssh/sshd_config' => {
#       ensure  => 'present',
#       path    => '/etc/ssh/sshd_config',
#       source  => 'puppet:///modules/ssh/sshd_config',
#       mode    => '0644',
#       require => Class[ssh::package],
#       notify  => Class[ssh::service],
#     },
#   },
# }
#
#
# Make the config a symlink to another file
#
# class { ssh::config::default :
#   configfiles => {
#     '/etc/ssh/sshd_config' => {
#       ensure  => 'link',
#       path    => '/etc/ssh/sshd_config',
#       target  => '/etc/ssh/sshd_config.dist',
#       mode    => '0644',
#       require => Class[ssh::package],
#       notify  => Class[ssh::service],
#     },
#   },
# }
#
class ssh::config::default(
  $configfiles = $ssh::params::configfiles,
  $configdir   = $ssh::params::configdir,
  $stage       = setup_infra,
) inherits ssh::params {

  include stdlib

  $files = keys($configfiles)

  validate_array($files)

  ssh::config::file { $files : config => $configfiles }

}
