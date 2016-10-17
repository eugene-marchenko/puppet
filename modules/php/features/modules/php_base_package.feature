Feature: php/base/packages.pp
  In order to manage packages necessary for php scripts to run, this class
  will install the necessary packages.

    Scenario: php::base::packages default
    Given a node named "php-base-packages-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name  | state   |
      | php5  | latest  |

    Scenario: php::base::packages no params
    Given a node named "php-base-packages-no-params"
    When I try to compile the catalog
    Then compilation should fail
