Feature: mlocate/services.pp
  In order to manage mlocate services on a system. This class must manage the
  services and ensure that they are either running or stopped and either enabled
  or not.

    Scenario: mlocate::services default
    Given a node named "class-mlocate-services-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a script "/etc/cron.daily/mlocate"

    Scenario: mlocate::services disabled 
    Given a node named "class-mlocate-services-disabled"
    When I try to compile the catalog
    Then compilation should succeed
    And file "/etc/cron.daily/mlocate" should be "absent"
