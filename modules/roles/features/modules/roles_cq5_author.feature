Feature: roles/cq5/author.pp
  In order to setup a cq5 author server, this role must create the necessary
  resources to run cq5 in author mode.

    Scenario: roles::cq5::author
    Given a node named "class-roles-cq5-author"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::cq5::author with required facts
    Given a node named "class-roles-cq5-author"
    And a fact "cq5_env" of "prod"
    And a fact "cq5_pass" of "admin"
    And a fact "aws_s3_db_backup_access_key" of "FOO"
    And a fact "aws_s3_db_backup_secret_key" of "BAR"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::base]"
    And there should be a resource "Exec[cq5::author(mkdir -p /opt/cq5/author)]"
    And there should be a resource "Mount[/opt/cq5/author]"
      And the resource should have an "ensure" of "mounted"
      And the resource should have a "device" of "/dev/mapper/elastic_drive-volume"
      And the resource should have an "options" of "defaults"
      And the resource should have a "fstype" of "xfs"
    And there should be a resource "Class[cq5]"
    And there should be a resource "Cq5::Node[author]"
      And the resource should have a "port" of "8080"
      And the resource should have a "path" of "/opt/cq5/author"
      And the resource should have a "mount" of "/opt/cq5/author"
      And the resource should have a "zapcat_port" of "10052"
      And the resource should have an "env" of "prod"
      And the resource should have a "role" of "author"
      And the resource should have a "heap_max" of "2048"
      And the resource should have a "max_files" of "65535"
      And the resource should have a "javaopts" of "-Dcom.day.crx.persistence.tar.IndexMergeDelay=0"
    And there should be a resource "Class[roles::cq5::jvm]"
    And there should be a resource "Class[java]"
    And there should be a resource "Cron::Crontab[ebs_snapshot_hourly_author]"
      And the resource should have "installed" set to "true"
      And the resource should have a "command" of "sync && /usr/local/bin/ebs-snapshot.py -r us-east-1 -t 24H instance -i i-123456"
    And there should be a resource "Cron::Crontab[datastore_gc_author]"
      And the resource should have "installed" set to "true"
      And the resource should have "enabled" set to "false"
      And the resource should have a "command" of "/usr/local/bin/cq5-datastore-gc.rb --host localhost --port 8080 --pass admin -d -s 2 -l DEBUG | logger -t cq5-datastore-gc"
    And there should be a resource "Cron::Crontab[tarpm_opt_author]"
      And the resource should have "installed" set to "true"
      And the resource should have "enabled" set to "false"
      And the resource should have a "command" of "/usr/local/bin/cq5-tar-optimization.rb --host localhost --port 8080 --pass admin --action start -l DEBUG | logger -t cq5-tar-optimization"
    And there should be a resource "Class[cq5::export]"
    And there should be a resource "Cron::Crontab[cat_author_index_tar]"
      And the resource should have a "minute" of "*/30"
      And the resource should have a "command" of "cat /opt/cq5/author/crx-quickstart/repository/workspaces/crx.default/index*.tar > /dev/null"
    And there should be a resource "Cron::Crontab[cq5_backup_users]"
      And the resource should have a "command" of "/usr/local/bin/cq5-export-package.py -p /home -e /home/a/admin --environment prod --host test.local --port 8080 --pass admin -n account_backup -b nw-backups"
    And there should be a resource "Cron::Crontab[audit_node_purge_author]"
      And the resource should have a "command" of "touch /opt/cq5/author/cleanAudit"
      And the resource should have a "templates" of "Template_Java_CQ5_CMS"
      And the resource should have a "hostgroups" of "Discovered Hosts"
      And the resource should have a "port" of "10052"
      And the resource should have a "username" of "zapi"
      And the resource should have a "password" of "zappy"
    And following packages should be dealt with:
    | name                | state   |
    | libcurl4-gnutls-dev | latest  |
    | curb                | latest  |
    | nokogiri            | 1.5.9   |
    And there should be a resource "Class[cq5::datastoregc]"

    Scenario: roles::cq5::author with optional facts
    Given a node named "class-roles-cq5-author"
    And a fact "env" of "prod"
    And a fact "cq5_pass" of "admin"
    And a fact "aws_s3_db_backup_access_key" of "FOO"
    And a fact "aws_s3_db_backup_secret_key" of "BAR"
    And a fact "cq5_author_path" of "/opt/cq/node1"
    And a fact "cq5_author_port" of "4502"
    And a fact "cq5_author_max_heap" of "4096"
    And a fact "cq5_author_mount_device" of "/dev/sdj"
    And a fact "cq5_author_mount_fstype" of "ext3"
    And a fact "roles" of "author"
    And a fact "ec2_placement_availability_zone" of "us-west-2a"
    And a fact "cq5_author_datastoregc_enabled" of "true"
    And a fact "cq5_author_tarpm_opt_enabled" of "true"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::base]"
    And there should be a resource "Exec[cq5::author(mkdir -p /opt/cq5/author)]"
    And there should be a resource "Mount[/opt/cq5/author]"
      And the resource should have an "ensure" of "mounted"
      And the resource should have a "device" of "/dev/sdj"
      And the resource should have an "options" of "defaults"
      And the resource should have a "fstype" of "ext3"
    And there should be a resource "Class[cq5]"
    And there should be a resource "Cq5::Node[author]"
      And the resource should have a "port" of "4502"
      And the resource should have a "path" of "/opt/cq/node1"
      And the resource should have a "mount" of "/opt/cq5/author"
      And the resource should have a "zapcat_port" of "10059"
      And the resource should have an "env" of "prod"
      And the resource should have a "role" of "author"
      And the resource should have a "heap_max" of "4096"
      And the resource should have a "max_files" of "65535"
      And the resource should have a "javaopts" of "-Dcom.day.crx.persistence.tar.IndexMergeDelay=0"
    And there should be a resource "Class[roles::cq5::jvm]"
    And there should be a resource "Class[java]"
    And there should be a resource "Cron::Crontab[ebs_snapshot_hourly_author]"
      And the resource should have "installed" set to "true"
      And the resource should have a "command" of "sync && /usr/local/bin/ebs-snapshot.py -r us-west-2 -t 24H instance -i i-123456"
    And there should be a resource "Cron::Crontab[datastore_gc_author]"
      And the resource should have "installed" set to "true"
      And the resource should have "enabled" set to "true"
      And the resource should have a "command" of "/usr/local/bin/cq5-datastore-gc.rb --host localhost --port 4502 --pass admin -d -s 2 -l DEBUG | logger -t cq5-datastore-gc"
    And there should be a resource "Cron::Crontab[tarpm_opt_author]"
      And the resource should have "installed" set to "true"
      And the resource should have "enabled" set to "true"
      And the resource should have a "command" of "/usr/local/bin/cq5-tar-optimization.rb --host localhost --port 4502 --pass admin --action start -l DEBUG | logger -t cq5-tar-optimization"
    And there should be a resource "Class[cq5::export]"
    And there should be a resource "Cron::Crontab[cat_author_index_tar]"
      And the resource should have a "minute" of "*/30"
      And the resource should have a "command" of "cat /opt/cq/node1/crx-quickstart/repository/workspaces/crx.default/index*.tar > /dev/null"
    And there should be a resource "Cron::Crontab[cq5_backup_users]"
      And the resource should have a "command" of "/usr/local/bin/cq5-export-package.py -p /home -e /home/a/admin --environment prod --host test.local --port 4502 --pass admin -n account_backup -b nw-backups"
    And there should be a resource "Cron::Crontab[audit_node_purge_author]"
      And the resource should have a "command" of "touch /opt/cq/node1/cleanAudit"
      And the resource should have a "templates" of "Template_Java_CQ5_CMS"
      And the resource should have a "hostgroups" of "Prod Author Servers"
      And the resource should have a "port" of "10059"
      And the resource should have a "username" of "zapi"
      And the resource should have a "password" of "zappy"
    And following packages should be dealt with:
    | name                | state   |
    | libcurl4-gnutls-dev | latest  |
    | curb                | latest  |
    | nokogiri            | 1.5.9   |
    And there should be a resource "Class[cq5::datastoregc]"


    Scenario: roles::cq5::author with facts
    Given a node named "class-roles-cq5-author"
    And a fact "env" of "uat"
    And a fact "cq5_pass" of "admin"
    And a fact "aws_s3_db_backup_access_key" of "FOO"
    And a fact "aws_s3_db_backup_secret_key" of "BAR"
    And a fact "cq5_author_mount_path" of "/opt/cq5"
    And a fact "cq5_author_max_heap" of "4096"
    And a fact "cq5_author_max_files" of "1024"
    And a fact "cq5_author_javaopts" of "-Dcrx.memoryMaxUsage=98 -Dcrx.memoryMinStdev=1 -Dcom.day.crx.persistence.tar.IndexMergeDelay=0"
    And a fact "roles" of "author"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::base]"
    And there should be a resource "Exec[cq5::author(mkdir -p /opt/cq5)]"
    And there should be a resource "Mount[/opt/cq5]"
      And the resource should have an "ensure" of "mounted"
      And the resource should have a "device" of "/dev/mapper/elastic_drive-volume"
      And the resource should have an "options" of "defaults"
      And the resource should have a "fstype" of "xfs"
    And there should be a resource "Class[cq5]"
    And there should be a resource "Cq5::Node[author]"
      And the resource should have a "port" of "8080"
      And the resource should have a "path" of "/opt/cq5/author"
      And the resource should have a "mount" of "/opt/cq5"
      And the resource should have an "env" of "uat"
      And the resource should have a "role" of "author"
      And the resource should have a "heap_max" of "4096"
      And the resource should have a "max_files" of "1024"
      And the resource should have a "javaopts" of "-Dcrx.memoryMaxUsage=98 -Dcrx.memoryMinStdev=1 -Dcom.day.crx.persistence.tar.IndexMergeDelay=0"
    And there should be a resource "Class[roles::cq5::jvm]"
    And there should be a resource "Class[java]"
    And there should be a resource "Cron::Crontab[ebs_snapshot_hourly_author]"
      And the resource should have "installed" set to "false"
      And the resource should have a "command" of "sync && /usr/local/bin/ebs-snapshot.py -r us-east-1 -t 24H instance -i i-123456"
    And there should be a resource "Class[cq5::export]"
    And there should be a resource "Cron::Crontab[cat_author_index_tar]"
      And the resource should have a "minute" of "*/30"
      And the resource should have a "command" of "cat /opt/cq5/author/crx-quickstart/repository/workspaces/crx.default/index*.tar > /dev/null"
    And there should be a resource "Cron::Crontab[cq5_backup_users]"
      And the resource should have a "command" of "/usr/local/bin/cq5-export-package.py -p /home -e /home/a/admin --environment uat --host test.local --port 8080 --pass admin -n account_backup -b nw-backups"
      And the resource should have a "templates" of "Template_Java_CQ5_CMS"
      And the resource should have a "hostgroups" of "UAT Author Servers"
      And the resource should have a "port" of "10052"
      And the resource should have a "username" of "zapi"
      And the resource should have a "password" of "zappy"
    And following packages should be dealt with:
    | name                | state   |
    | libcurl4-gnutls-dev | latest  |
    | curb                | latest  |
    | nokogiri            | 1.5.9   |
    And there should be a resource "Class[cq5::datastoregc]"

