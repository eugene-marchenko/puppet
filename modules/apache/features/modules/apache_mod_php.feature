Feature: apache/mod/php.pp
  In order to manage mod-php for apache on a system. This class must take 
  a hash of mod-php packages and either install or uninstall them. It should 
  also manage whether php is enabled or not. 

    Scenario: apache::mod::php default
    Given a node named "class-apache-mod-php-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[apache]"
    And following packages should be dealt with:
      | name                | state   |
      | libapache2-mod-php5 | latest  |
    And there should be a resource "A2mod[php5]"
      And the state should be "present"

    Scenario: apache::mod::php invalid hash
    Given a node named "class-apache-mod-php-invalid-hash"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: apache::mod::php uninstalled 
    Given a node named "class-apache-mod-php-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[apache]"
    And following packages should be dealt with:
      | name                | state   |
      | libapache2-mod-php5 | absent  |
