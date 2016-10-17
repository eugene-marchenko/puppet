Feature: cron/package.pp
  In order to cronor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: cron::package default
    Given a node named "cron-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name  | state   |
      | cron | latest  |

    Scenario: cron::package no parameters
    Given a node named "cron-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
