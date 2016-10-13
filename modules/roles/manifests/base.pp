# Class: roles::base
#
# This class installs base resources
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# None.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# include roles::base
#
# class { 'roles::base' : }
#
#
class roles::base() {

  include stdlib

  # Validate some necessary facts
  if ! $::aws_snapshotter_access_key {
    fail('aws_snapshotter_access_key fact not set')
  }

  if ! $::aws_snapshotter_secret_key {
    fail('aws_snapshotter_secret_key fact not set')
  }

  # include dhcp
  # include lvm2
  # include hosts
  include roles::packages
  # hosts::manage { 'meta-data' : ip => '169.254.169.254' }
  # include ntp
  # include cron
  # include mlocate
  # file {'/mnt/log': ensure => directory, owner => 'root', group => 'root', mode => '0755' }
  # include build
  # include build::devlibs
  # include python
  # include python::pip::packages
  # include route53
  # include ruby
  # include ruby::gem::packages
  # include sysstat
  # include postfix
  # include monit
  # include logwatch
  # include logrotate
  # include git
  # include shells
  # include sysctl
  # include rsyslog
  # include newrelic

  # class { 'users' : override => true }
  # include sudo
  # postfix::mailalias { 'root' : recipient => 'webops@thedailybeast.com' }
  # sudo::config::sudoer { '10-defaults-insults' : content => 'Defaults insults' }
  # python::package { 'python-dateutil' : }
  # class { 'aws::ec2::ebs::snapshot' :
  #   accesskey => $::aws_snapshotter_access_key,
  #   secretkey => $::aws_snapshotter_secret_key,
  # }
  # Get Region info
  # $region = regsubst($::ec2_placement_availability_zone, '^(us|sa|eu|ap)-(north|northeast|south|southeast|east|west)-([0-9]+)[a-z]$', '\1-\2-\3')
  # cron::crontab { 'ebs_snapshot' :
  #   minute  => fqdn_rand(60),
  #   hour    => '8',
  #   command => "sync && /usr/local/bin/ebs-snapshot.py -r ${region} -t 1m instance -i ${::ec2_instance_id}",
  # }
  package { 'popularity-contest' : ensure => 'absent' }
  file { '/var/log/upstart' : ensure => 'directory' }

  # if $env =~ /prod|production|mgmt/ {
  #   Cron::Crontab <| title == 'ebs_snapshot' |> {
  #     installed => true
  #   }
  # } else {
  #   Cron::Crontab <| title == 'ebs_snapshot' |> {
  #     installed => true
  #   }
  # }

  anchor{'roles::base::begin':}
  -> Class[dhcp]
  # -> Class[lvm2]
  # -> Class[hosts]
  # -> Hosts::Manage['meta-data']
  # -> Class[ntp]
  # -> Class[cron]
  # -> Class[mlocate]
  # -> File['/mnt/log']
  # -> Class[build]
  # -> Class[python]
  # -> Class[route53]
  # -> Class[ruby]
  # -> Class[sysstat]
  # -> Class[postfix]
  # -> Class[monit]
  # -> Class[logwatch]
  # -> Class[logrotate]
  # -> Class[git]
  # -> Class[shells]
  # -> Class[sysctl]
  # -> Class[rsyslog]
  # -> Class[users]
  # -> Class[sudo]
  # -> Postfix::Mailalias[root]
  # -> Sudo::Config::Sudoer['10-defaults-insults']
  # -> Python::Package['python-dateutil']
  # -> Class[aws::ec2::ebs::snapshot]
  # -> Cron::Crontab['ebs_snapshot']
  # -> Package['popularity-contest']
  # -> File['/var/log/upstart']
  -> anchor{'roles::base::end':}
}
