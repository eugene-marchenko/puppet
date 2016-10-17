Feature: logwatch/packages.pp
  In order to manage packages necessary for logwatch scripts to run, this class
  will install the necessary packages.

    Scenario: logwatch::package default
    Given a node named "logwatch-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name   | state   |
      | logwatch | latest  |

    Scenario: logwatch::package no params
    Given a node named "logwatch-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
