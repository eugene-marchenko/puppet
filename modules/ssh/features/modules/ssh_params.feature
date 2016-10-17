Feature: params.pp
  In order to have a basic ssh running, the ssh class
  should be able to use params to do the heavy lifting of determine
  configuration options based off of environment.

    Scenario: Class ssh::params
    Given a node named "class-params"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[Ssh::Params]"

    Scenario: Include ssh::params duplicate
    Given a node named "class-params-include-dup"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[Ssh::Params]"

    Scenario: Class ssh::params duplicate
    Given a node named "class-params-dup"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: Class ssh::params mix
    Given a node named "class-params-mix"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: Class ssh::params mix2
    Given a node named "class-params-mix2"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    And there should be a resource "Class[Ssh::Params]"

    Scenario: Class ssh::params called with parameter
    Given a node named "class-params-with-parameter"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: Class ssh::params with an invalid OS
    Given a node named "class-params"
    And a fact "operatingsystem" of "SunOS"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: Class ssh::params with unsupported puppetversion
    Given a node named "class-params-unsupported-puppetversion"
    And a fact "puppetversion" of "2.6.9"
    When I try to compile the catalog
    Then compilation should fail
