Feature: apache/mod/python.pp
  In order to manage mod-python for apache on a system. This class must take 
  a hash of mod-python packages and either install or uninstall them. It should 
  also manage whether python is enabled or not. 

    Scenario: apache::mod::python default
    Given a node named "class-apache-mod-python-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[apache]"
    And following packages should be dealt with:
      | name                  | state   |
      | libapache2-mod-python | latest  |
    And there should be a resource "A2mod[python]"
      And the state should be "present"

    Scenario: apache::mod::python invalid hash
    Given a node named "class-apache-mod-python-invalid-hash"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: apache::mod::python uninstalled 
    Given a node named "class-apache-mod-python-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[apache]"
    And following packages should be dealt with:
      | name                  | state   |
      | libapache2-mod-python | absent  |
