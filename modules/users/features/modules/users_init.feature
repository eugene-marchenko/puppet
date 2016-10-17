Feature: users.pp
  In order to install default resources, the users.pp class should be run.

  Scenario: Default installed
  Given a node named "class-user-init-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And user "root" should be "present"
  And key "root" should be "present"
  And group "sysadmins" should be "present"

  Scenario: Default installed from hiera
  Given a node named "class-user-init-hiera"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And user "johndoe" should be "present"
  And user "janedoe" should be "present"
  And key "johndoe" should be "present"
  And key "janedoe" should be "present"
  And group "sysadmins" should be "present"
  And group "developers" should be "present"

  Scenario: Multiple user types should be installed
  Given a node named "class-user-init-hiera-multiple-groups"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And group "sysadmins" should be "present"
  And group "developers" should be "present"
  And user "johndoe" should be "present"
  And user "janedoe" should be "present"
  And user "marlow" should be "present"
  And key "johndoe" should be "present"
  And key "janedoe" should be "present"
  And key "marlow" should be "present"

  Scenario: User type from non-standard group key
  Given a node named "class-user-init-non-standard-groupkey"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And group "wheel" should be "present"
  And user "rusty" should be "present"
