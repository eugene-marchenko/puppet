Feature: roles/cron/mysql/backups.pp
  In order to backup mysql databases, this class must install the necessary
  resources and to setup cronjobs that execute a backup script.

    Scenario: roles::cron::mysql::backups no facts
    Given a node named "class-roles-cron-mysql-backups"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::cron::mysql::backups from facts
    Given a node named "class-roles-cron-mysql-backups"
    And a fact "aws_s3_db_backup_access_key" of "FOO"
    And a fact "aws_s3_db_backup_secret_key" of "BAR"
    And a fact "w3pw_dbhost" of "w3pw.test.local"
    And a fact "w3pw_dbuser" of "w3pw"
    And a fact "w3pw_dbpass" of "bar"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[mysql::backup]"
    And there should be a resource "Class[mysql]"
    And there should be a resource "Cron::Crontab[w3pwdb_backup]"
      And the resource should have a "command" of "/usr/local/bin/mysql-backup.py -d w3pw --host w3pw.test.local -u w3pw -p bar -c s3 -b nw-backups -p /databases/w3pw"
    And there should be a resource "Cron::Crontab[w3pwdb_new_backup]"
      And the resource should have a "command" of "/usr/local/bin/mysql-backup.py -d w3pw_new --host w3pw.test.local -u w3pw -p bar -c s3 -b nw-backups -p /databases/w3pw"
