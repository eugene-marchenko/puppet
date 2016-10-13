Feature: release.pp
  In order to have effective package management
  The apt class should be able to specify a release to help manage packages

  Scenario: Class of apt::release
  Given a node named "class-release"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve

  And there should be a resource "Class[Apt::Params]"

  And there should be a resource "Class[Apt::Release]"
    And the resource should have a "release_id" of "lenny"

  And there should be a resource "File[/etc/apt/apt.conf.d/01release]"
    And the file should have an "owner" of "root"
    And the file should have a "group" of "root"
    And the file should have a "mode" of "644"
    And the file should have a "content" that includes "APT::Default-Release"
    And the file should have a "content" that includes "lenny"

  Scenario:
  Given a node named "class-release-duplicate"
  When I compile the catalog
  Then the compilation should fail
