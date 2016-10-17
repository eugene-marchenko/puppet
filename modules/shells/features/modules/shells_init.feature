Feature: shells/init.pp
  In order to manage shells on a system. The shells class should by default
  install the shells package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: shells default
  Given a node named "class-shells-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/shells" should be "present"
    And the file should contain "/bin/false"

  Scenario: shells removed
  Given a node named "class-shells-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be no resource "File[/etc/shells]"
