Feature: jetty/service.pp
  In order to jettyor services on a system. This define must take a hash of
  services to install and create them.

    Scenario: jetty::service default
    Given a node named "jetty-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "jetty" should be "running"

    Scenario: jetty::service no parameters
    Given a node named "jetty-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Service[jetty]"
