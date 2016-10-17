Feature: git/packages.pp
  In order to manage packages necessary for git scripts to run, this class
  will install the necessary packages.

    Scenario: git::package default
    Given a node named "git-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name      | state   |
      | git       | latest  |
      | git-core  | latest |

    Scenario: git::package no params
    Given a node named "git-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
