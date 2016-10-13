Feature: apt debian/unstable.pp
  In order to have effective package management
  The apt class needs to have unstable coverage
  And this covers unstable.pp
  
  Scenario: Basic apt::debian::unstable instance with defaults
    Given a node named "class-apt-debian-unstable"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    And there should be a resource "Class[Apt::Params]"

    And there should be a resource "Class[Apt::Debian::Unstable]"
    And there should be a resource "Apt::Source[debian_unstable]"
      And the resource should have a "location" of "http://debian.mirror.iweb.ca/debian/"
      And the resource should have a "release" of "unstable"
      And the resource should have a "repos" of "main contrib non-free"
      And the resource should have a "required_packages" of "debian-keyring debian-archive-keyring" 
      And the resource should have a "key" of "55BE302B"
      And the resource should have a "key_server" of "subkeys.pgp.net"
      And the resource should have a "pin" of "-10"

  Scenario:
    Given a node named "class-apt-debian-unstable-params"
    When I compile the catalog
    Then the compilation should fail

    Scenario:
    Given a node named "class-apt-debian-unstable-duplicate"
    When I compile the catalog
    Then the compilation should fail
  
