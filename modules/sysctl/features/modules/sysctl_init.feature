Feature: sysctl/init.pp
  In order to manage sysctl on a system. The sysctl class should by default
  install the sysctl package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: sysctl default
  Given a node named "class-sysctl-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/sysctl.conf"
  And following directories should be created:
    | name              |
    | /etc/sysctl.d |
  And following packages should be dealt with:
    | name    | state   |
    | procps  | latest  |
  And exec "service procps start" should be present

  Scenario: sysctl removed
  Given a node named "class-sysctl-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be no resource "Package[procps]"
  And there should be no resource "File[/etc/sysctl/sysctl.conf]"
  And there should be no resource "File[/etc/sysctl.d]"
  And there should be no resource "Exec['service procps start']"

  Scenario: sysctl complex install
  Given a node named "sysctl-complex-install"
  When I try to compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/sysctl.d/60-foo.conf"
