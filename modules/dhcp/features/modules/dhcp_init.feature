Feature: dhcp/init.pp
  In order to manage dhcp on a system. The dhcp class should by default
  install the dhcp package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: dhcp default
  Given a node named "class-dhcp-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a resource "File_line[/etc/dhcp/dhclient.conf]"
    And the file should contain /prepend domain-name \"local \";/
  And exec "/etc/init.d/networking restart" should be present
    And the resource should have a "logoutput" of "on_failure"
    And the resource should have "refreshonly" set to "true"

  Scenario: dhcp removed
  Given a node named "class-dhcp-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be no resource "Package[isc-dhcp-client]"
  And there should be no resource "File_line[/etc/dhcp/dhclient.conf]"
  And there should be no resource "Exec[/etc/init.d/networking restart]"
