Feature: hosts/config.pp
  In order to hostsor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: hosts::config default
    Given a node named "hosts-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/hosts" should be "present"

    Scenario: hosts::config no parameters
    Given a node named "hosts-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
