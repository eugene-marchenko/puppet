Feature: puppet/init.pp
  In order to manage puppet on a system. The main puppet class should
  by default install the puppet client. It should have the ability to
  remove the puppet client (anticlass). It should also have the ability
  to install and configure the puppetmaster and uninstall the puppetmaster.

    Scenario: puppet default
    Given a node named "class-puppet-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/puppet/puppet.conf"
    And there should be a file "/etc/default/puppet"
    And service "puppet" should be "stopped"
    And following packages should be dealt with:
      | name    |  state  |
      | puppet  | latest  |

    Scenario: puppet with master
    Given a node named "class-puppet-with-master"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/puppet/puppet.conf"
    And there should be a file "/etc/default/puppet"
    And there should be a file "/etc/puppet/auth.conf"
    And there should be a file "/etc/puppet/fileserver.conf"
    And there should be a file "/etc/apache2/sites-available/puppetmaster"
    And service "puppet" should be "stopped"
    And following packages should be dealt with:
      | name                    |  state  |
      | puppet                  |  latest |
      | puppetmaster-common     |  latest |
      | puppetmaster-passenger  |  latest |

    Scenario: puppet both client/master removed
    Given a node named "class-puppet-client-master-removed"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "File[/etc/puppet/puppet.conf]"
    And there should be no resource "File[/etc/default/puppet]"
    And there should be no resource "File[/etc/puppet/puppet.conf]"
    And there should be no resource "File[/etc/puppet/auth.conf]"
    And there should be no resource "File[/etc/puppet/fileserver.conf]"
    And there should be no resource "File[/etc/apache2/sites-available/puppetmaster]"
    And there should be no resource "Service[puppet]"
    And following packages should be dealt with:
      | name                    |  state  |
      | puppet                  |  purged |
      | puppetmaster-common     |  purged |
      | puppetmaster-passenger  |  purged |
