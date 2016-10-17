Feature: vsftpd/service.pp
  In order to vsftpdor services on a system. This define must take a hash of
  services to install and create them.

    Scenario: vsftpd::service default
    Given a node named "vsftpd-service-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And service "vsftpd" should be "running"

    Scenario: vsftpd::service uninstalled
    Given a node named "vsftpd-service-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Service[vsftpd]"
