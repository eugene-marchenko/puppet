Feature: varnish/package.pp
  In order to varnishor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: varnish::package default
    Given a node named "varnish-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name          | state   |
      | varnish       | latest  |
      | libvmod-var   | latest  |
      | libvmod-curl  | latest  |

    Scenario: varnish::package no parameters
    Given a node named "varnish-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
