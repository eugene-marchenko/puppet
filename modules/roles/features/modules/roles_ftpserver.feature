Feature: roles/ftpserver.pp
  In order to setup an ftp  server, this role must create the necessary
  resources to run ftp and allow users to access it through ftp.

    Scenario: roles::ftpserver
    Given a node named "class-roles-ftpserver"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::misc::mounts]"
    And there should be a resource "Mount[/opt]"
    And there should be a resource "Class[vsftpd]"
    And there should be a resource "File[/opt/ftp]"
    And group "ftpusers" should be "present"
    And user "foo" should be "present"
    And there should be no resource "Ssh_authorized_key[foo]"
    And user "bar" should be "present"
    And there should be no resource "Ssh_authorized_key[bar]"
    And user "baz" should be "absent"
    And there should be no resource "Ssh_authorized_key[baz]"
