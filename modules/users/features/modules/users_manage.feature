Feature: users/manage.pp
  In order to install groups/users/key based off group names since puppet has
  no iterative capabilities, users::manage works to find the group/users/key
  config from either default data or an external source to seed the other 
  defines with proper information for user creation.

  Scenario: Manage sysadmins from params
  Given a node named "define-manage-sysadmins-from-params"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And user "root" should be "present"
  And key "root" should be "present"

  Scenario: Manage sysadmins from hiera
  Given a node named "define-manage-sysadmins-from-hiera"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And user "johndoe" should be "present"
  And key "johndoe" should be "present"
  And user "janedoe" should be "present"
  And key "janedoe" should be "present"

  Scenario: Manage sysadmins no ssh
  Given a node named "define-manage-sysadmins-no-ssh"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And user "johndoe" should be "present"
  And user "janedoe" should be "present"
  And there should be no resource "Ssh_authorized_key[johndoe]"
  And there should be no resource "Ssh_authorized_key[janedoe]"

  Scenario: Manage multiple user types
  Given a node named "define-manage-multiple-user-types"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And user "johndoe" should be "present"
  And user "janedoe" should be "present"
  And user "marlow" should be "present"

  Scenario: Manage users from group not found
  Given a node named "define-manage-users-from-group-not-found"
  When I try to compile the catalog
  Then compilation should fail
