Feature: monit/service.pp
  In order to monitor services on a system. This define must take a hash of
  services to install and create them.

    Scenario: monit::service default
    Given a node named "monit-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "monit" should be "running"

    Scenario: monit::service uninstalled
    Given a node named "monit-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Service[monit]"
