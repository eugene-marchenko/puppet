Feature: roles/cron/secgrp/check.pp
  In order to check security groups, this class must install the necessary
  resources to setup a cronjob that executes a script to check them.

    Scenario: roles::cron::secgrp::check no facts
    Given a node named "class-roles-cron-secgrp-check"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::cron::secgrp::check from facts
    Given a node named "class-roles-cron-secgrp-check"
    And a fact "aws_secgrp_operator_access_key" of "FOO"
    And a fact "aws_secgrp_operator_secret_key" of "BAR"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[aws::ec2::security::group::check]"
    And there should be a resource "Cron::Crontab[check_secgrps]"
