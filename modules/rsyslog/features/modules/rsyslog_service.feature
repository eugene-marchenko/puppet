Feature: rsyslog/service.pp
  In order to manage rsyslog services on a system. This class must take a hash of
  services to install and create them.

    Scenario: rsyslog::service default
    Given a node named "rsyslog-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "rsyslog" should be "running"

    Scenario: rsyslog::service uninstalled 
    Given a node named "rsyslog-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Service[rsyslog]"
