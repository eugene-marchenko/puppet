Feature: monit/init.pp
  In order to manage monit on a system. The monit class should by default
  install the monit package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: monit default
  Given a node named "class-monit-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/monit/monitrc" should be "present"
    And the file should contain "set daemon 120"
  And file "/etc/default/monit" should be "present"
    And the file should contain "START=yes"
  And following directories should be created:
    | name              |
    | /etc/monit/conf.d |
  And following packages should be dealt with:
    | name  | state   |
    | monit | latest  |
  And service "monit" should be "running"

  Scenario: monit removed
  Given a node named "class-monit-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
  | name  | state   |
  | monit | purged  |
  And there should be no resource "File[/etc/monit/monitrc]"
  And there should be no resource "File[/etc/default/monit]"
  And there should be no resource "File[/etc/monit/monit.d]"
  And there should be no resource "Service[monit]"

  Scenario: monit complex install
  Given a node named "monit-complex-install"
  When I try to compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/monit/conf.d/foo" should be "present"

  Scenario: monit complex install invalid
  Given a node named "monit-complex-install-invalid"
  When I try to compile the catalog
  Then compilation should fail
