Feature: mysql/backup.pp
  In order to backup mysql databases. This class should install the
  mysql-backup script from either direct content, a puppet source, or a template.
  It should setup proper execution and ownership parameters and place the file
  in a sane location.

    Scenario: mysql::backup default
    Given a node named "mysql-backup-default"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: mysql::backup with required params
    Given a node named "mysql-backup-required-params"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/mysql-backup.py"
      And the file should contain "ACCESSKEY='FOO'"
      And the file should contain "SECRETKEY='BAR'"

    Scenario: mysql::backup from source diff path
    Given a node named "mysql-backup-from-source-diff-path"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/bin/snapshot.pl"
      And the file should have a "source" of "puppet:///modules/mysql/scripts/backup.pl"

    Scenario: mysql::backup from content
    Given a node named "mysql-backup-from-content"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/mysql-backup.py"
      And the file should contain "foo"

    Scenario: mysql::backup uninstalled
    Given a node named "mysql-backup-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/usr/local/bin/mysql-backup.py" should be "absent"
