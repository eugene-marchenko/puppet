Feature: roles/cronserver.pp
  In order to have a cronserver running infrastructural cron tasks, this meta
  class must install the necessary roles to create a cron server.

    Scenario: roles::cronserver no facts
    Given a node named "class-roles-cronserver"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::cronserver from facts
    Given a node named "class-roles-cronserver"
    And a fact "aws_snap_rotator_access_key" of "FOO"
    And a fact "aws_snap_rotator_secret_key" of "BAR"
    And a fact "aws_s3_db_backup_access_key" of "FOO"
    And a fact "aws_s3_db_backup_secret_key" of "BAR"
    And a fact "aws_secgrp_operator_access_key" of "FOO"
    And a fact "aws_secgrp_operator_secret_key" of "BAR"
    And a fact "w3pw_dbhost" of "w3pw.test.local"
    And a fact "w3pw_dbname" of "pvault"
    And a fact "w3pw_dbuser" of "w3pw"
    And a fact "w3pw_dbpass" of "bar"
    And a fact "nw_analytics_omniture_user" of "FOO"
    And a fact "nw_analytics_omniture_pass" of "FOO"
    And a fact "nw_analytics_aws_access_key" of "FOO"
    And a fact "nw_analytics_aws_secret_key" of "FOO"
    And a fact "github_user" of "FOO"
    And a fact "github_pass" of "BAR"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::cron::snapshot::rotator]"
    And there should be a resource "Class[roles::cron::mysql::backups]"
    And there should be a resource "Class[roles::cron::analytics]"
    And there should be a resource "Class[roles::cron::secgrp::check]"
    And there should be a resource "Class[roles::cron::secgrp::export]"
    And there should be a resource "Class[roles::cron::digital]"
    And there should be a resource "Class[roles::cron::github]"
