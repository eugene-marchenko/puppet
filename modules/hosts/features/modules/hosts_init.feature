Feature: hosts/init.pp
  In order to manage hosts on a system. The hosts class should by default
  install the hosts package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: hosts default
  Given a node named "class-hosts-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/hosts" should be "present"

  Scenario: hosts removed
  Given a node named "class-hosts-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be no resource "File[/etc/hosts]"

  Scenario: hosts complex install
  Given a node named "hosts-complex-install"
  When I try to compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a resource "Host[amazon]"
    And the resource should have an "ip" of "169.254.169.254"
