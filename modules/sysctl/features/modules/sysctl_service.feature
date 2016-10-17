Feature: sysctl/service.pp
  In order to manage sysctl services on a system. This define must take a hash of
  services to install and create them.

    Scenario: sysctl::service default
    Given a node named "sysctl-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And exec "service procps start" should be present
      And the resource should have "refreshonly" set to "true"
      And the resource should have an "logoutput" of "on_failure"

    Scenario: sysctl::service uninstalled
    Given a node named "sysctl-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Exec[service procps start]"
