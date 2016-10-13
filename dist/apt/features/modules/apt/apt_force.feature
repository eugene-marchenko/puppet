Feature: force.pp
  In order to have effective package management
  The apt class should be able to use force to help manage packages

  Scenario: Default define of apt::force
  Given a node named "define-force"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve

  And there should be a resource "Apt::Force[force-default]"
    And the resource should have a "release" of "testing"
    And the resource should have "version" set to "false"

  And there should be a resource "Apt::Force[force-params]"
    And the resource should have a "release" of "stable"
    And the resource should have a "version" of "123"

  And there should be a resource "Exec[/usr/bin/aptitude -y -t testing install force-default]"
    And the exec should have an "unless" of "/usr/bin/dpkg -l | grep force-default"

  And there should be a resource "Exec[/usr/bin/aptitude -y -t stable install force-params]"
    And the exec should have an "unless" of "/usr/bin/dpkg -l | grep force-params | grep 123"

  Scenario: 
  Given a node named "define-force-fail"
  When I compile the catalog
  Then the compilation should fail
