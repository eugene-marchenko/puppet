Feature: puppet/client.pp
  In order to manage puppet on a system. The puppet client class should
  ensure that the puppet client and it's associated packages, configs, and
  services are managed.

    Scenario: puppet::client default
    Given a node named "class-puppet-client-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/puppet/puppet.conf"
    And there should be a file "/etc/default/puppet"
    And service "puppet" should be "disabled"
    And following packages should be dealt with:
      | name           |  state  |
      | puppet         |  latest |

    Scenario: puppet::client removed
    Given a node named "class-puppet-client-removed"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "File[/etc/puppet/puppet.conf]"
    And there should be no resource "File[/etc/default/puppet]"
    And there should be no resource "Service[puppet]"
    And following packages should be dealt with:
      | name           |  state  |
      | puppet         |  purged |

    Scenario: puppet::client invalid packages param
    Given a node named "class-puppet-client-invalid-packages-param"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: puppet::client invalid defaults param
    Given a node named "class-puppet-client-invalid-defaults-param"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: puppet::client invalid configs param
    Given a node named "class-puppet-client-invalid-configs-param"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: puppet::client invalid services param
    Given a node named "class-puppet-client-invalid-services-param"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: puppet::client invalid remove param
    Given a node named "class-puppet-client-invalid-remove-param"
    When I try to compile the catalog
    Then compilation should fail
