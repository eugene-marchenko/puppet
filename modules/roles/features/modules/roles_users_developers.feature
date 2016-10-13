Feature: roles/users/developers.pp
  In order for a node to install developers, this role should create the users
  and allow them sudo access to the system.

    Scenario: roles::users::developers 
    Given a node named "class-roles-users-developers"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And user "johnny" should be "present"
    And there should be a resource "Sudo::Config::Sudoer[johnny]"
