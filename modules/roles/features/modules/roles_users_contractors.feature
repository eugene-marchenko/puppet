Feature: roles/users/contractors.pp
  In order for a node to install contractors, this role should create the users
  and allow them sudo access to the system.

    Scenario: roles::users::contractors 
    Given a node named "class-roles-users-contractors"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And user "vladimir" should be "present"
    And there should be a resource "Sudo::Config::Sudoer[vladimir]"
