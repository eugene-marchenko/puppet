Feature: skeleton/init.pp
  In order to manage skeleton on a system. The skeleton class should by default
  install the skeleton package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: skeleton default
  Given a node named "class-skeleton-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a resource "Class[skeleton::packages]"
    And the resource should have "installed" set to "true"
    And the resource should have a "version" of "latest"
  And there should be a resource "Class[skeleton::configs]"
    And the resource should have "installed" set to "true"
  And there should be a resource "Class[skeleton::services]"
    And the resource should have "enabled" set to "true"
    And the resource should have "running" set to "true"

  Scenario: skeleton removed
  Given a node named "class-skeleton-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And there should be a resource "Class[skeleton::packages]"
    And the resource should have "installed" set to "false"
  And there should be a resource "Class[skeleton::configs]"
    And the resource should have "installed" set to "false"
