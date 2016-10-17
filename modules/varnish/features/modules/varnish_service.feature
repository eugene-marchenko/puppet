Feature: varnish/service.pp
  In order to varnishor services on a system. This define must take a hash of
  services to install and create them.

    Scenario: varnish::service default
    Given a node named "varnish-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "varnish" should be "running"
    And service "varnishncsa" should be "running"
    And service "varnishlog" should be "stopped"

    Scenario: varnish::service uninstalled 
    Given a node named "varnish-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And there should be no resource "Service[varnish]"
    And there should be no resource "Service[varnishncsa]"
    And there should be no resource "Service[varnishlog]"
