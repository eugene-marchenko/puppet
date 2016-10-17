Feature: jetty/init.pp
  In order to manage jetty on a system. The jetty class should by default
  install the jetty package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: jetty default
  Given a node named "class-jetty-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/default/jetty" should be "present"
  And there should be a script "/etc/init.d/jetty"
  And following packages should be dealt with:
    | name  | state   |
    | jetty | latest  |
  And service "jetty" should be "running"

  Scenario: jetty removed
  Given a node named "class-jetty-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
  | name  | state   |
  | jetty | purged  |
  And there should be no resource "File[/etc/default/jetty]"
  And there should be no resource "File[/etc/init.d/jetty]"
  And there should be no resource "Service[jetty]"

  Scenario: jetty install complex
  Given a node named "class-jetty-complex"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
