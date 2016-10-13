Feature: hosts/manage.pp
  In order to manage hosts on a system. This define must take a
  host ip and arbitrary list of names and add them to the hosts file.

    Scenario: hosts::manage one host
    Given a node named "hosts-manage-one-host"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Host[amazon]"
      And the resource should have an "ip" of "169.254.169.254"

    Scenario: hosts::manage with host aliases
    Given a node named "hosts-manage-aliases"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Host[server1.test.local]"
      And the resource should have an "ip" of "127.0.0.1"
      And the resource should have an "host_aliases" of "server1,srv1"

    Scenario: hosts::manage with comment
    Given a node named "hosts-manage-with-comment"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Host[foo]"
      And the resource should have an "ip" of "127.0.0.1"
      And the resource should have a "comment" of "just testing"
