Feature: apache/mod/wsgi.pp
  In order to manage mod-wsgi for apache on a system. This class must take 
  a hash of mod-wsgi packages and either install or uninstall them. It should 
  also manage whether wsgi is enabled or not. 

    Scenario: apache::mod::wsgi default
    Given a node named "class-apache-mod-wsgi-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[apache]"
    And following packages should be dealt with:
      | name                | state   |
      | libapache2-mod-wsgi | latest  |
    And there should be a resource "A2mod[wsgi]"
      And the state should be "present"

    Scenario: apache::mod::wsgi invalid hash
    Given a node named "class-apache-mod-wsgi-invalid-hash"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: apache::mod::wsgi uninstalled 
    Given a node named "class-apache-mod-wsgi-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[apache]"
    And following packages should be dealt with:
      | name                | state   |
      | libapache2-mod-wsgi | absent  |
