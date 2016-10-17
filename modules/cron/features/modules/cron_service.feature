Feature: cron/service.pp
  In order to manage cron services on a system. This define must take a hash of
  services to install and create them.

    Scenario: cron::service default
    Given a node named "cron-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "cron" should be "running"

    Scenario: cron::service uninstalled 
    Given a node named "cron-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And there should be no resource "Service[cron]"
