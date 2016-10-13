Feature: roles/cron/snapshot/rotator.pp
  In order to rotate snapshots, this class must install the necessary resources
  to setup a cronjob that executes a rotation script.

    Scenario: roles::cron::snapshot::rotator no facts
    Given a node named "class-roles-cron-snapshot-rotator"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::cron::snapshot::rotator from facts
    Given a node named "class-roles-cron-snapshot-rotator"
    And a fact "aws_snap_rotator_access_key" of "FOO"
    And a fact "aws_snap_rotator_secret_key" of "BAR"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[aws::ec2::ebs::snapshot::rotation]"
    And there should be a resource "Cron::Crontab[rotate_snapshots_us_east_1]"
    And there should be a resource "Cron::Crontab[rotate_snapshots_us_west_2]"
