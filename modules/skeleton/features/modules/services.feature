Feature: skeleton/services.pp
  In order to manage skeleton services on a system. This class must manage the
  services and ensure that they are either running or stopped and either enabled
  or not.

    Scenario: skeleton::services default
    Given a node named "class-skeleton-services-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "skeleton" should be "running"
      And the service should have "enable" set to "true"

    Scenario: skeleton::services disabled 
    Given a node named "class-skeleton-services-disabled"
    When I try to compile the catalog
    Then compilation should succeed
    And service "skeleton" should be "running"
      And the service should have "enable" set to "false"

    Scenario: skeleton::services stopped
    Given a node named "class-skeleton-services-stopped"
    When I try to compile the catalog
    Then compilation should succeed
    And service "skeleton" should be "stopped"
      And the service should have "enable" set to "true"
