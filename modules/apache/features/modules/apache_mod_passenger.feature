Feature: apache/mod/passenger.pp
  In order to manage mod-passenger for apache on a system. This class must take 
  a hash of mod-passenger packages and either install or uninstall them. It should 
  also manage whether passenger is enabled or not. 

    Scenario: apache::mod::passenger default
    Given a node named "class-apache-mod-passenger-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[apache]"
    And following packages should be dealt with:
      | name                  | state   |
      | libapache2-mod-passenger | latest  |
    And there should be a resource "A2mod[passenger]"
      And the state should be "present"

    Scenario: apache::mod::passenger invalid hash
    Given a node named "class-apache-mod-passenger-invalid-hash"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: apache::mod::passenger uninstalled 
    Given a node named "class-apache-mod-passenger-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[apache]"
    And following packages should be dealt with:
      | name                  | state   |
      | libapache2-mod-passenger | absent  |
