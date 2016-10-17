# Define: cron::crontab
#
# This module installs custom crontabs for running arbitrary scheduled commands.
#
# == Parameters:
#
# == Required:
#
# $command::        The command to run.
#
# == Optional:
#
# $installed::      Whether the files are installed or not.
#
# $enabled::        Whether the command is enabled or disabled.
#
# $minute::         The minute of the hour this should run. Defaults to 56.
#
# $hour::           The hour of the day this should run. Defaults to 6am.
#
# $day_of_month::   The day of the month this should run. Defaults to everyday.
#
# $month::          The month this should run. Defaults to every month.
#
# $day_of_week::    The day of the week this should run. Defaults to everyday.
#
# $user::           The user to run this as. Defaults to root.
#
# $comment::        A comment to describe the command being run.
#
# $environment::    Configures necessary environment variables.
#
# == Requires:
#
# stdlib, cron::params
#
# == Sample Usage:
#
# cron::crontab { 'remove_backups' :
#   command => 'find /opt/backups -mtime +7 | xargs rm -f'
# }
#
# cron::crontab { 'remove_backups' :
#   command     => 'find /opt/backups -mtime +7 | xargs rm -f',
#   environment => 'PATH=/usr/bin:/usr/sbin:/bin:/sbin',
#   comment     => 'Remove backups greater than 7 days old',
# }
#
# cron::crontab { 'remove_backups' :
#   command => 'find /opt/backups -mtime +7 | xargs rm -f',
#   minute  => '30',
#   hour    => '10',
# }
#
define cron::crontab(
  $command,
  $installed    = true,
  $enabled      = true,
  $minute       = '56',
  $hour         = '6',
  $day_of_month = '*',
  $month        = '*',
  $day_of_week  = '*',
  $user         = 'root',
  $comment      = undef,
  $environment  = undef,
) {

  include stdlib

  validate_bool($installed)

  case $installed {
    true: {
      file { "/etc/cron.d/${name}":
        ensure  => 'present',
        path    => "/etc/cron.d/${name}",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('cron/Ubuntu/crontab.erb'),
        tag     => "${name}-crontab",
      }
    }
    false:  {
      file { "/etc/cron.d/${name}": ensure => 'absent' }
    }
    default: {}
  }
}
