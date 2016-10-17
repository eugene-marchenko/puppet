Feature: apache/ssl.pp
  In order to manage apache ssl on a system. This class must take a hash of
  ssl files to install and create them.

    Scenario: apache::ssl default
    Given a node named "class-apache-ssl-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/ssl/private/apache-ssl-key.key" should be "present"
      And the file should have a "group" of "ssl-cert"
      And the file should have a "mode" of "0640"
    And there should be a file "/etc/ssl/certs/apache-ssl-cert.pem"
    And there should be a file "/etc/ssl/certs/apache-ssl-chain.pem"
    And there should be a resource "A2mod[ssl]"
      And the state should be "present"

    Scenario: apache::ssl uninstalled 
    Given a node named "class-apache-ssl-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And there should be no resource "File[/etc/ssl/private/apache-ssl-key.key]"
    And there should be no resource "File[/etc/ssl/certs/apache-ssl-cert.pem]"
    And there should be no resource "File[/etc/ssl/certs/apache-ssl-chain.pem]"
    And there should be a resource "A2mod[ssl]"
      And the state should be "absent"
