Feature: dhcp/config.pp
  In order to manage dhcp services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: dhcp::config default
    Given a node named "dhcp-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "File_line[/etc/dhcp/dhclient.conf]"
      And the file should contain /prepend domain-name \"local \";/

    Scenario: dhcp::config no parameters
    Given a node named "dhcp-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
