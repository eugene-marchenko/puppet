Feature: dhcp/service.pp
  In order to dhcpor services on a system. This define must take a hash of
  services to install and create them.

    Scenario: dhcp::service default
    Given a node named "dhcp-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And exec "/etc/init.d/networking restart" should be present
      And the resource should have a "logoutput" of "on_failure"
      And the resource should have "refreshonly" set to "true"

    Scenario: dhcp::service uninstalled
    Given a node named "dhcp-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Exec[/etc/init.d/networking restart]"
