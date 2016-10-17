Feature: snmpd/config.pp
  In order to monitor resources with snmp on a system. This define must take a 
  hash of configs to configure snmpd properly.

    Scenario: snmpd::config default
    Given a node named "snmpd-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/snmpd/snmpd.conf" should be "present"
    And file "/etc/snmpd/snmp.conf" should be "present"
    And file "/etc/snmpd/snmptrapd.conf" should be "present"
    And file "/etc/default/snmpd" should be "present"

    Scenario: snmpd::config no parameters
    Given a node named "snmpd-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
