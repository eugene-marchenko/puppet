Feature: ntp/services.pp
  In order to manage ntp services on a system. This class must manage the
  services and ensure that they are either running or stopped and either enabled
  or not.

    Scenario: ntp::services default
    Given a node named "class-ntp-services-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "ntp" should be "running"
      And the service should have "enable" set to "true"

    Scenario: ntp::services disabled 
    Given a node named "class-ntp-services-disabled"
    When I try to compile the catalog
    Then compilation should succeed
    And service "ntp" should be "running"
      And the service should have "enable" set to "false"

    Scenario: ntp::services stopped
    Given a node named "class-ntp-services-stopped"
    When I try to compile the catalog
    Then compilation should succeed
    And service "ntp" should be "stopped"
      And the service should have "enable" set to "true"
