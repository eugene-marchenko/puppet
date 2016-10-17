Feature: cron/crontab.pp
  In order to run scheduled commands on a system. This define must take a
  command and optional scheduling information and create a crontab file.

    Scenario: cron::crontab remove_backups
    Given a node named "cron-crontab-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/cron.d/remove_backups" should be "present"
      And the file should contain "56 6 * * * root find /opt/backups -type f -mtime +7 | xargs rm -f"

    Scenario: cron::crontab remove_backups
    Given a node named "cron-crontab-removed"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/cron.d/remove_backups" should be "absent"

    Scenario: cron::crontab remove_backups with options
    Given a node named "cron-crontab-options"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/cron.d/remove_backups" should be "present"
      And the file should contain "# just testing"
      And the file should contain "PATH=/usr/sbin:/usr/bin:/sbin:/bin"
      And the file should contain "*/5 1 1 2 1 foobar find /opt/backups -type f -mtime +7 | xargs rm -f"

    Scenario: cron::crontab remove_backups command disabled
    Given a node named "cron-crontab-disabled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/cron.d/remove_backups" should be "present"
      And the file should contain "#56 6 * * * root find /opt/backups -type f -mtime +7 | xargs rm -f"

    Scenario: cron::crontab no params
    Given a node named "cron-crontab-no-params"
    When I try to compile the catalog
    Then compilation should fail 
