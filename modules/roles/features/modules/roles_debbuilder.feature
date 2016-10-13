Feature: roles/debbuilder.pp
  In order to setup a server with the tools necessary to create debian packages.
  This class must install the necessary packages and help files to do so.

    Scenario: roles::debbuilder 
    Given a node named "class-roles-debbuilder"
    When I try to compile the catalog
    Then compilation should succeed
    And there should be a resource "Class[build::devtools]"
    And there should be a resource "Class[roles::backports]"
    And there should be a resource "Motd::Register[Debian-Notice]"
    And file "/root/.gnupg" should be "directory"
      And the file should have a "mode" of "0700"
    And file "/root/.gnupg/gpg.conf" should be "present"
      And the file should have a "mode" of "0600"
    And file "/root/.gnupg/pubring.gpg" should be "present"
      And the file should have a "mode" of "0600"
    And file "/root/.gnupg/secring.gpg" should be "present"
      And the file should have a "mode" of "0600"
    And file "/root/.gnupg/trustdb.gpg" should be "present"
      And the file should have a "mode" of "0600"
