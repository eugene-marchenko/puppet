Feature:  init.pp
  In order to have effective package management
  The apt class needs to have certain files
  And run some execs
  
    Scenario: Basic class with defaults
    Given a node named "class-init-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    And there should be a resource "Class[Apt]"
      And the class should have "disable_keys" set to "false"
      And the class should have "always_apt_update" set to "false"

    And there should be a resource "Class[Apt::Params]"

    And there should be a resource "File[sources.list]"
      And the file should have an "owner" of "root"
      And the file should have a "group" of "root"
      And the file should have a "mode" of "0644"
      And the file should have a "name" of "/etc/apt/sources.list"
      And the file should have an "ensure" of "present"
      
    And there should be a resource "File[sources.list.d]"
      And the directory should have an "owner" of "root"
      And the directory should have a "group" of "root"
      And the directory should have an "ensure" of "directory"
      And the directory should have a "name" of "/etc/apt/sources.list.d"
    
    And there should be a resource "Exec[apt_update]"
      And the exec should have a "command" of "/usr/bin/apt-get update"
      And the exec should have "refreshonly" set to "true"

    And there should not be a resource "Exec[make-apt-insecure]"
      
    And there should be a resource "Package[python-software-properties]"

Scenario: Basic class with params
    Given a node named "class-init-params"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    And there should be a resource "Class[Apt]"
      And the class should have "disable_keys" set to "true"
      And the class should have "always_apt_update" set to "true"

    And there should be a resource "Class[Apt::Params]"

    And there should be a resource "File[sources.list]"
      And the file should have an "owner" of "root"
      And the file should have a "group" of "root"
      And the file should have a "mode" of "0644"
      And the file should have a "name" of "/etc/apt/sources.list"
      And the file should have an "ensure" of "present"
      
    And there should be a resource "File[sources.list.d]"
      And the directory should have an "owner" of "root"
      And the directory should have a "group" of "root"
      And the directory should have an "ensure" of "directory"
      And the directory should have a "name" of "/etc/apt/sources.list.d"
    
    And there should be a resource "Exec[apt_update]"
      And the exec should have a "command" of "/usr/bin/apt-get update"
      And the exec should have "refreshonly" set to "false"
      
    And there should be a resource "Exec[make-apt-insecure]"
      And the exec should have a "creates" of "/etc/apt/apt.conf.d/99unauth"
      And the exec should have a "command" that includes "APT::Get::AllowUnauthenticated 1;"
      And the exec should have a "command" that includes "/etc/apt/apt.conf.d/99unauth"
      And the exec should have a "command" that includes "/bin/echo"

    And there should be a resource "Package[python-software-properties]"


  Scenario: 
  Given a node named "class-init-duplicate"
  When I compile the catalog
  Then the compilation should fail

  Scenario:
  Given a node named "class-init-extra-param"
  When I compile the catalog
  Then the compilation should fail
