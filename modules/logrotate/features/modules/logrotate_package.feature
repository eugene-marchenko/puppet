Feature: logrotate/package.pp
  In order to logrotateor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: logrotate::package default
    Given a node named "logrotate-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name  | state   |
      | logrotate | latest  |

    Scenario: logrotate::package no parameters
    Given a node named "logrotate-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
