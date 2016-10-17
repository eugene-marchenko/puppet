Feature: users/default/groups.pp
  In order to install groups that have consistent gids, the 
  users::groups class should be run.

  Scenario: Default groups installed
  Given a node named "class-user-groups"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And group "sysadmins" should be "present"
    And the group should have a "gid" of "500"

  Scenario: Default groups overriden
  Given a node named "class-user-groups-hiera"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And group "sysadmins" should be "present"
    And the group should have a "gid" of "501"
  And group "developers" should be "present"
    And the group should have a "gid" of "502"

  Scenario: Default groups overriden with different key
  Given a node named "class-user-groups-hiera-diff-key"
  When I try to compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And group "wheel" should be "present"
    And the group should have a "gid" of "500"

  Scenario: Default groups override with different key not found
  Given a node named "class-user-groups-hiera-diff-key-not-found"
  When I try to compile the catalog
  Then compilation should fail
