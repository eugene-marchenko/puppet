Feature: roles/pvault.pp
  In order to setup a server with to run the password vault. This class
  must create the necessary virtualhost resources and the w3pw class
  for those vhosts to run.

    Scenario: roles::pvault 
    Given a node named "class-roles-pvault"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::pvault with facts
    Given a node named "class-roles-pvault"
    And a fact "w3pw_dbhost" of "test.local"
    And a fact "w3pw_dbname" of "w3pw_test"
    And a fact "w3pw_dbuser" of "w3pwuser"
    And a fact "w3pw_dbpass" of "w3pwpass"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::backports]"
    And there should be a resource "Class[apache]"
    And there should be a resource "Class[apache::mod::php]"
    And there should be a resource "Class[apache::ssl]"
    And there should be a resource "Class[w3pw]"
    And there should be a resource "A2mod[rewrite]"
    And there should be a resource "A2site[pvault.ec2.thedailybeast.com_80]"
    And there should be a resource "A2site[pvault.ec2.thedailybeast.com_443]"
    And there should be a file "/etc/apache2/sites-available/pvault.ec2.thedailybeast.com_80"
    And there should be a file "/etc/apache2/sites-available/pvault.ec2.thedailybeast.com_443"
