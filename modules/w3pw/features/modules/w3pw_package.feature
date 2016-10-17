Feature: w3pw/package.pp
  In order to w3pwor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: w3pw::package default
    Given a node named "w3pw-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name  | state   |
      | w3pw  | latest  |

    Scenario: w3pw::package no parameters
    Given a node named "w3pw-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
