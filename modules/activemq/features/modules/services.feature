Feature: activemq/services.pp
  In order to manage activemq services on a system. This class must manage the
  services and ensure that they are either running or stopped and either enabled
  or not.

    Scenario: activemq::services default
    Given a node named "class-activemq-services-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "activemq" should be "running"
      And the service should have "enable" set to "true"

    Scenario: activemq::services disabled 
    Given a node named "class-activemq-services-disabled"
    When I try to compile the catalog
    Then compilation should succeed
    And service "activemq" should be "running"
      And the service should have "enable" set to "false"

    Scenario: activemq::services stopped
    Given a node named "class-activemq-services-stopped"
    When I try to compile the catalog
    Then compilation should succeed
    And service "activemq" should be "stopped"
      And the service should have "enable" set to "true"
