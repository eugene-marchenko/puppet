Feature: postfix/service.pp
  In order to postfixor services on a system. This define must take a hash of
  services to install and create them.

    Scenario: postfix::service default
    Given a node named "postfix-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "postfix" should be "running"

    Scenario: postfix::service uninstalled
    Given a node named "postfix-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Service[postfix]"
