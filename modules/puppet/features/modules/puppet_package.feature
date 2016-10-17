Feature: puppet/package.pp
  In order to manage puppet on a system. The puppet package define should
  ensure that packages passed to it will be managed.

    Scenario: puppet::package from params
    Given a node named "define-puppet-package-from-params"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
    | name          | state   |
    | puppet-common | latest  |
    | puppet        | latest  |

    Scenario: puppet::package no parameters
    Given a node named "define-puppet-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
