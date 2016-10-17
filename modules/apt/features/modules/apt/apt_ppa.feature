Feature: ppa.pp
  In order to have effective package management
  The apt class should be able to use ppas to help manage packages

  Scenario: Default define of apt::ppa
  Given a node named "define-ppa"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve

  And there should be a resource "Class[Apt]"
    And the class should have a "before" of "Apt::Ppa[default], Apt::Ppa[other]"
    And the class should have "disable_keys" set to "false"
    And the class should have "always_apt_update" set to "false"
    

  And there should be a resource "Apt::Ppa[default]"
  And there should be a resource "Apt::Ppa[other]"

  And there should be a resource "Exec[apt-update-default]"
    And the exec should have a "command" of "/usr/bin/aptitude update"
    And the exec should have "refreshonly" set to "true"

  And there should be a resource "Exec[add-apt-repository-default]"
    And the exec should have a "command" of "/usr/bin/add-apt-repository default"
    And the exec should have a "notify" of "Exec[apt-update-default]"

  And there should be a resource "Exec[apt-update-other]"
    And the exec should have a "command" of "/usr/bin/aptitude update"
    And the exec should have "refreshonly" set to "true"

  And there should be a resource "Exec[add-apt-repository-other]"
    And the exec should have a "command" of "/usr/bin/add-apt-repository other"
    And the exec should have a "notify" of "Exec[apt-update-other]"

  Scenario: 
  Given a node named "define-ppa-fail"
  When I compile the catalog
  Then the compilation should fail

  Scenario:
  Given a node named "define-ppa-also-fail"
  When I compile the catalog
  Then the compilation should fail
