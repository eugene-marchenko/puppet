Feature: puppet/config.pp
  In order to manage puppet on a system. The puppet config define should
  ensure that configs passed to it will be managed.

    Scenario: puppet::config from params
    Given a node named "define-puppet-config-from-params"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/puppet/puppet.conf"
    And there should be a file "/etc/default/puppet"
      And the file should contain "START=yes"
      And the file should contain "DAEMON_OPTS"

    Scenario: puppet::config from facts
    Given a node named "define-puppet-config-from-facts"
    And a fact "puppet_daemon_opts" of "--onetime"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/default/puppet"
      And the file should contain "--onetime"

    Scenario: puppet::config no parameters
    Given a node named "define-puppet-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
