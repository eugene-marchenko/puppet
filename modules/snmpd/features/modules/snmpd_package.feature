Feature: snmpd/package.pp
  In order to snmpdor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: snmpd::package default
    Given a node named "snmpd-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name  | state   |
      | snmpd | latest  |

    Scenario: snmpd::package no parameters
    Given a node named "snmpd-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
