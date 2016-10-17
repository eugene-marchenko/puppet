Feature: apache/package.pp
  In order to apacheor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: apache::package default
    Given a node named "apache-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name    | state   |
      | apache2 | latest  |

    Scenario: apache::package no parameters
    Given a node named "apache-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
