Feature: snmpd/service.pp
  In order to manage snmpd services on a system. This define must take a hash of
  services to install and create them.

    Scenario: snmpd::service default
    Given a node named "snmpd-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "snmpd" should be "running"

    Scenario: snmpd::service uninstalled 
    Given a node named "snmpd-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And there should be no resource "Service[snmpd]"
