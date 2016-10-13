Feature: roles/cron/secgrp/export.pp
  In order to export security groups, this class must install the necessary
  resources to setup a cronjob that executes a script to export them.

    Scenario: roles::cron::secgrp::export no facts
    Given a node named "class-roles-cron-secgrp-export"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::cron::secgrp::export from facts
    Given a node named "class-roles-cron-secgrp-export"
    And a fact "aws_secgrp_operator_access_key" of "FOO"
    And a fact "aws_secgrp_operator_secret_key" of "BAR"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[aws::ec2::security::group::export]"
    And there should be a resource "Cron::Crontab[diff_secgrps]"
    And there should be a resource "Cron::Crontab[export_secgrps]"
