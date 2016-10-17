Feature: jmeter/packages.pp
  In order to manage packages necessary for jmeter scripts to run, this class
  will install the necessary packages.

    Scenario: jmeter::package default
    Given a node named "jmeter-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name   | state   |
      | jmeter | latest  |

    Scenario: jmeter::package no params
    Given a node named "jmeter-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
