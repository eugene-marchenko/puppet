Feature: postfix/package.pp
  In order to postfixor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: postfix::package default
    Given a node named "postfix-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name  | state   |
      | postfix | latest  |

    Scenario: postfix::package no parameters
    Given a node named "postfix-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
