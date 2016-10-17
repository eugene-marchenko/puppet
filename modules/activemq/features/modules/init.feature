Feature: activemq/init.pp
  In order to manage activemq on a system. The activemq class should by default
  install the activemq package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: activemq default
  Given a node named "class-activemq-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a resource "Class[activemq::packages]"
    And the resource should have "installed" set to "true"
  And there should be a resource "Class[activemq::configs]"
    And the resource should have "installed" set to "true"
  And there should be a resource "Class[activemq::services]"
    And the resource should have "enabled" set to "true"
    And the resource should have "running" set to "true"

  Scenario: activemq removed
  Given a node named "class-activemq-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And there should be a resource "Class[activemq::packages]"
    And the resource should have "installed" set to "false"
  And there should be a resource "Class[activemq::configs]"
    And the resource should have "installed" set to "false"
  And there should be a resource "Class[activemq::services]"
    And the resource should have "enabled" set to "false"
    And the resource should have "running" set to "false"
