Feature: pin.pp
  In order to have effective package management
  The apt class should be able to use pins to manage packages

  Scenario: Default define of apt::pin
  Given a node named "define-pin"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve

  And there should be a resource "Class[Apt::Params]"

  And there should be a resource "Apt::Pin[pin-default]"
    And the resource should have a "packages" of "*"
    And the resource should have a "priority" of "0"

  And there should be a resource "Apt::Pin[pin-with-params]"
    And the resource should have a "packages" of "mysql"
    And the resource should have a "priority" of "788"

  And there should be a resource "File[pin-default.pref]"
    And the file should have an "owner" of "root"
    And the file should have a "group" of "root"
    And the file should have a "mode" of "644"
    And the file should have an "ensure" of "file"
    And the file should have a "name" of "/etc/apt/preferences.d/pin-default"
    And the file should have a "content" of "# pin-default\nPackage: *\nPin: release a=pin-default\nPin-Priority: 0"

  And there should be a resource "File[pin-with-params.pref]"
    And the file should have an "owner" of "root"
    And the file should have a "group" of "root"
    And the file should have a "mode" of "644"
    And the file should have an "ensure" of "file"
    And the file should have a "name" of "/etc/apt/preferences.d/pin-with-params"
    And the file should have a "content" of "# pin-with-params\nPackage: mysql\nPin: release a=pin-with-params\nPin-Priority: 788"

  Scenario: 
  Given a node named "define-pin-fail"
  When I compile the catalog
  Then the compilation should fail
