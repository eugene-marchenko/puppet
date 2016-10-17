Feature: users/manage/user.pp
  In order to manage multiple users on a system, the users::manage::user define
  must ensure that the user is either present or absent.

  Scenario: User with complete config
  Given a node named "define-user-complete-config"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And user "johndoe" should be "present"
    And the user should have a "shell" of "/bin/bash"
    And the user should have a "uid" of "2000"
    And the user should have a "gid" of "users"
    And the user should have a "home" of "/home/johndoe"
    And the user should have a "password" of "$1AAAAAAAAAAAAAAAAAAAAAA"
    And the user should have a "comment" of "John Doe"

  Scenario: User with incomplete config options 
  Given a node named "define-user-incomplete-config"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And user "johndoe" should be "present"
    And the user should have a "uid" of "2000"
    And the user should have a "shell" of "/bin/bash"
    And the user should have a "home" of "/home/johndoe"
    And the user should have no "password"

  Scenario: User with ensure overriden
  Given a node named "define-user-ensure-overriden"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And user "johndoe" should be "absent"

  Scenario: System user
  Given a node named "define-user-system-user"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And user "jetty" should be "present"
    And the user should have a "uid" of "50"
    And the user should have a "gid" of "65534"
    And the user should have a "home" of "/usr/share/jetty"
    And the user should have a "shell" of "/bin/false"
    And the user should have "system" set to "true"

  Scenario: User with invalid ensure
  Given a node named "define-user-invalid-ensure"
  When I try to compile the catalog
  Then compilation should fail

  Scenario: User with no config
  Given a node named "define-user-no-config"
  When I try to compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And user "janedoe" should be "present"
    And the user should have a "uid" of "2002"
    And the user should have a "gid" of "users"
    And the user should have a "home" of "/home/janedoe"
    And the user should have a "shell" of "/bin/bash"
    And the user should have a "password" of "$1AAAAAAAAAAAAAAAAAAAAAA"
    And the user should have a "comment" of "Jane Doe"
