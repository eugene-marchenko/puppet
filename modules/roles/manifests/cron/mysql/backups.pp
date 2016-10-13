# Class: roles::cron::mysql::backups
#
# This class installs cron::mysql::backups resources
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
# include roles::cron::mysql::backups
#
# class { 'roles::cron::mysql::backups' : }
#
#
class roles::cron::mysql::backups() {

  include roles::base

  # Validate some necessary facts
  if ! $::aws_s3_db_backup_access_key {
    fail('aws_s3_db_backup_access_key fact not set')
  }

  if ! $::aws_s3_db_backup_secret_key {
    fail('aws_s3_db_backup_secret_key fact not set')
  }

  if ! $::w3pw_dbhost {
    fail('w3pw_dbhost fact not set')
  }

  if ! $::w3pw_dbuser {
    fail('w3pw_dbuser fact not set')
  }

  if ! $::w3pw_dbpass {
    fail('w3pw_dbpass fact not set')
  }

  include mysql

  class { 'mysql::backup' :
    accesskey => $::aws_s3_db_backup_access_key,
    secretkey => $::aws_s3_db_backup_secret_key,
  }

  cron::crontab { 'w3pwdb_backup' :
    minute  => '0',
    hour    => '4',
    command => "/usr/local/bin/mysql-backup.py -d w3pw --host ${::w3pw_dbhost} -u
    ${::w3pw_dbuser} -p ${::w3pw_dbpass} -c s3 -b nw-backups -p /databases/w3pw",
  }

  # Use chaining to order the resources
  Class[roles::base]
  -> Class[mysql]
  -> Class[mysql::backup]
  -> Cron::Crontab['w3pwdb_backup']
}
