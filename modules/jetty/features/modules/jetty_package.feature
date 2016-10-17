Feature: jetty/package.pp
  In order to jettyor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: jetty::package default
    Given a node named "jetty-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name  | state   |
      | jetty | latest  |

    Scenario: jetty::package no parameters
    Given a node named "jetty-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
