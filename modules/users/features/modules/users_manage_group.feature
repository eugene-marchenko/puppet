Feature: users/manage/group.pp
  In order to manage multiple groups on a system, the users::manage::group 
  define must ensure that the group is either present or absent.

  Scenario: Group with complete config
  Given a node named "define-group-complete-config"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And group "sysadmins" should be "present"
    And the group should have a "gid" of "501"

  Scenario: Group with incomplete config options 
  Given a node named "define-group-incomplete-config"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And group "developers" should be "present"
    And the user should have no "gid"

  Scenario: Group with ensure overriden
  Given a node named "define-group-ensure-overriden"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And group "contractors" should be "absent"

  Scenario: System group 
  Given a node named "define-group-system-group"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And group "jetty" should be "present"
    And the user should have a "gid" of "48"

  Scenario: User with invalid ensure
  Given a node named "define-group-invalid-ensure"
  When I try to compile the catalog
  Then compilation should fail

  Scenario: User with no config
  Given a node named "define-group-no-config"
  When I try to compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And group "developers" should be "present"
    And the user should have a "gid" of "502"
