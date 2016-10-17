Feature: ntp/init.pp
  In order to manage ntp on a system. The ntp class should by default
  install the ntp package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: ntp default
  Given a node named "class-ntp-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a resource "Class[ntp::packages]"
    And the resource should have "installed" set to "true"
  And there should be a resource "Class[ntp::configs]"
    And the resource should have "installed" set to "true"
  And there should be a resource "Class[ntp::services]"
    And the resource should have "enabled" set to "true"
    And the resource should have "running" set to "true"

  Scenario: ntp removed
  Given a node named "class-ntp-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And there should be a resource "Class[ntp::packages]"
    And the resource should have "installed" set to "false"
  And there should be a resource "Class[ntp::configs]"
    And the resource should have "installed" set to "false"
  And there should be a resource "Class[ntp::services]"
    And the resource should have "enabled" set to "false"
    And the resource should have "running" set to "false"
