Feature: apache/init.pp
  In order to manage apache on a system. The apache class should by default
  install the apache package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: apache default
  Given a node named "class-apache-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/apache2/apache2.conf" should be "present"
  And file "/etc/apache2/envvars" should be "present"
  And file "/etc/apache2/conf.d/security" should be "present"
  And file "/etc/apache2/conf.d/charset" should be "present"
  And file "/etc/apache2/conf.d/host_logging" should be "present"
  And file "/etc/default/apache2" should be "present"
  And file "/etc/logrotate.d/apache2" should be "present"
  And following packages should be dealt with:
    | name    | state   |
    | apache2 | latest  |
  And service "apache2" should be "running"

  Scenario: apache removed
  Given a node named "class-apache-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
    | name    | state   |
    | apache2 | purged  |
  And there should be no resource "File[/etc/apache2/apache2.conf]"
  And there should be no resource "File[/etc/apache2/envvars]"
  And there should be no resource "File[/etc/apache2/conf.d/security]"
  And there should be no resource "File[/etc/apache2/conf.d/charset]"
  And there should be no resource "File[/etc/apache2/conf.d/host_logging]"
  And there should be no resource "File[/etc/default/apache2]"
  And there should be no resource "File[/etc/logrotate.d/apache2]"
  And there should be no resource "Service[apache2]"
