Feature: resolver/init.pp
  In order to manage dns resolution on a system. The resolver class should by
  default install the resolver package, config files, and ensure sure necessary
  services are running. It should provide an ability to remove itself as well.

  Scenario: resolver default
  Given a node named "class-resolver-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/resolv.conf" should be "present"
    And the file should contain "nameserver 18.72.0.3"

  Scenario: resolver removed
  Given a node named "class-resolver-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be no resource "File[/etc/resolv.conf]"
