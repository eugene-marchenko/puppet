Feature: vsftpd/package.pp
  In order to vsftpdor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: vsftpd::package default
    Given a node named "vsftpd-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name  | state   |
      | vsftpd | latest  |

    Scenario: vsftpd::package no parameters
    Given a node named "vsftpd-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
