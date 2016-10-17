Feature: apache/service.pp
  In order to manage apache services on a system. This define must take a hash of
  services to install and create them.

    Scenario: apache::service default
    Given a node named "apache-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "apache2" should be "running"

    Scenario: apache::service uninstalled 
    Given a node named "apache-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And there should be no resource "Service[apache2]"
