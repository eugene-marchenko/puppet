Feature: mysql/packages.pp
  In order to manage packages necessary for mysql scripts to run, this class
  will install the necessary packages.

    Scenario: mysql::package default
    Given a node named "mysql-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name          | state   |
      | mysql-client  | latest  |

    Scenario: mysql::package no params
    Given a node named "mysql-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
