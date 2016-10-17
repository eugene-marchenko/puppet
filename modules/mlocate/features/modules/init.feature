Feature: mlocate/init.pp
  In order to manage mlocate on a system. The mlocate class should by default
  install the mlocate package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: mlocate default
  Given a node named "class-mlocate-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a resource "Class[mlocate::packages]"
    And the resource should have "installed" set to "true"
    And the resource should have a "version" of "latest"
  And there should be a resource "Class[mlocate::configs]"
    And the resource should have "installed" set to "true"
  And there should be a resource "Class[mlocate::services]"
    And the resource should have "enabled" set to "true"

  Scenario: mlocate removed
  Given a node named "class-mlocate-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And there should be a resource "Class[mlocate::packages]"
    And the resource should have "installed" set to "false"
  And there should be a resource "Class[mlocate::configs]"
    And the resource should have "installed" set to "false"
