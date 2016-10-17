Feature: puppet/master.pp
  In order to manage puppet on a system. The puppet master class should
  ensure that the puppet master and it's associated packages, configs, and
  services are managed.

    Scenario: puppet::master default
    Given a node named "class-puppet-master-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "master-/etc/puppet/puppet.conf"
    And there should be a file "/etc/puppet/auth.conf"
    And there should be a file "/etc/puppet/fileserver.conf"
    And there should be a file "/etc/apache2/sites-available/puppetmaster"
    And following packages should be dealt with:
      | name                    |  state  |
      | puppetmaster-common     |  latest |
      | puppetmaster-passenger  |  latest |

    Scenario: puppet::master removed
    Given a node named "class-puppet-master-removed"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "File[master-/etc/puppet/puppet.conf]"
    And there should be no resource "File[/etc/puppet/auth.conf]"
    And there should be no resource "File[/etc/puppet/fileserver.conf]"
    And there should be no resource "File[/etc/apache2/sites-available/puppetmaster]"
    And following packages should be dealt with:
      | name                    |  state  |
      | puppetmaster-common     |  purged |
      | puppetmaster-passenger  |  purged |

    Scenario: puppet::master invalid packages param
    Given a node named "class-puppet-master-invalid-packages-param"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: puppet::master invalid defaults param
    Given a node named "class-puppet-master-invalid-defaults-param"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: puppet::master invalid configs param
    Given a node named "class-puppet-master-invalid-configs-param"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: puppet::master invalid services param
    Given a node named "class-puppet-master-invalid-services-param"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: puppet::master invalid remove param
    Given a node named "class-puppet-master-invalid-remove-param"
    When I try to compile the catalog
    Then compilation should fail
