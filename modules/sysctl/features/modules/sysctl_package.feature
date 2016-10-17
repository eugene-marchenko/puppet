Feature: sysctl/package.pp
  In order to sysctlor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: sysctl::package default
    Given a node named "sysctl-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name    | state   |
      | procps  | latest  |

    Scenario: sysctl::package no parameters
    Given a node named "sysctl-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
