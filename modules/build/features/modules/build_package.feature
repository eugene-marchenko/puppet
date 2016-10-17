Feature: build/packages.pp
  In order to manage packages necessary for build scripts to run, this class
  will install the necessary packages.

    Scenario: build::package default
    Given a node named "build-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name            | state   |
      | build-essential | latest  |

    Scenario: build::package no params
    Given a node named "build-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
