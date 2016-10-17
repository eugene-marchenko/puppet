Feature: sasl/service.pp
  In order manage sasl services on a system. This define must take a hash of
  services to install and create them.

    Scenario: sasl::service default
    Given a node named "sasl-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "saslauthd" should be "stopped"

    Scenario: sasl::service uninstalled 
    Given a node named "sasl-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Service[saslauthd]"
