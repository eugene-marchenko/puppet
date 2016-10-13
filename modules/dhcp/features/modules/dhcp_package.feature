Feature: dhcp/package.pp
  In order to dhcpor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: dhcp::package default
    Given a node named "dhcp-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name            | state   |
      | isc-dhcp-client | latest  |

    Scenario: dhcp::package no parameters
    Given a node named "dhcp-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
