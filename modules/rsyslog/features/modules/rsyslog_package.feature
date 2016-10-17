Feature: rsyslog/package.pp
  In order to rsyslogor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: rsyslog::package default
    Given a node named "rsyslog-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name          | state   |
      | rsyslog       | latest  |
      | rsyslog-doc   | latest  |
      | rsyslog-relp  | latest  |

    Scenario: rsyslog::package no parameters
    Given a node named "rsyslog-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
