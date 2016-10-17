Feature: puppet/service.pp
  In order to manage puppet on a system. The puppet service define should
  ensure that services passed to it will be managed.

    Scenario: puppet::service from params
    Given a node named "define-puppet-service-from-params"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "puppet" should be "disabled"

    Scenario: puppet::service no parameters
    Given a node named "define-puppet-service-no-params"
    When I try to compile the catalog
    Then compilation should fail
