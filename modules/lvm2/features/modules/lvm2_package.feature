Feature: lvm2/packages.pp
  In order to manage packages necessary for lvm2 scripts to run, this class
  will install the necessary packages.

    Scenario: lvm2::package default
    Given a node named "lvm2-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name   | state   |
      | lvm2 | latest  |

    Scenario: lvm2::package no params
    Given a node named "lvm2-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
