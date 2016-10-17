Feature: nw_analytics/package.pp
  In order to nw_analyticsor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: nw_analytics::package default
    Given a node named "nw_analytics-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name  | state   |
      | nw-analytics  | latest  |

    Scenario: nw_analytics::package no parameters
    Given a node named "nw_analytics-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
