Feature: snmpd/init.pp
  In order to manage snmpd on a system. The snmpd class should by default
  install the snmpd package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: snmpd default
  Given a node named "class-snmpd-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/snmpd/snmpd.conf" should be "present"
  And file "/etc/snmpd/snmp.conf" should be "present"
  And file "/etc/snmpd/snmptrapd.conf" should be "present"
  And file "/etc/default/snmpd" should be "present"
  And following packages should be dealt with:
    | name  | state   |
    | snmpd | latest  |
  And service "snmpd" should be "running"

  Scenario: snmpd removed
  Given a node named "class-snmpd-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
  | name  | state   |
  | snmpd | purged  |
  And there should be no resource "File[/etc/snmpd/snmpd.conf]"
  And there should be no resource "File[/etc/snmpd/snmp.conf]"
  And there should be no resource "File[/etc/snmpd/snmptrapd.conf]"
  And there should be no resource "File[/etc/default/snmpd]"
  And there should be no resource "Service[snmpd]"
