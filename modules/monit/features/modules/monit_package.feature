Feature: monit/package.pp
  In order to monitor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: monit::package default
    Given a node named "monit-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name  | state   |
      | monit | latest  |

    Scenario: monit::package no parameters
    Given a node named "monit-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
