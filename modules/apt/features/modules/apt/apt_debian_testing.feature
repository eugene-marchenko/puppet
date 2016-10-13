Feature: apt debian/testing.pp
  In order to have effective package management
  The apt class needs to have testing coverage
  And this covers testing.pp
  
  Scenario: Basic apt::debian::testing with defaults
    Given a node named "class-apt-debian-testing"
    When I try to compile its catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    And there should be a resource "Class[Apt::Params]"

    And there should be a resource "Class[Apt::Debian::Testing]"
    And there should be a resource "Apt::Source[debian_testing]"
      And the resource should have a "location" of "http://debian.mirror.iweb.ca/debian/"
      And the resource should have a "release" of "testing"
      And the resource should have a "repos" of "main contrib non-free"
      And the resource should have a "required_packages" of "debian-keyring debian-archive-keyring" 
      And the resource should have a "key" of "55BE302B"
      And the resource should have a "key_server" of "subkeys.pgp.net"
      And the resource should have a "pin" of "-10"
  
  Scenario:
    Given a node named "class-apt-debian-testing-params"
    When I compile the catalog
    Then the compilation should fail

    Scenario:
    Given a node named "class-apt-debian-testing-duplicate"
    When I compile the catalog
    Then the compilation should fail
  
