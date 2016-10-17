Feature: postfix/init.pp
  In order to manage postfix on a system. The postfix class should by default
  install the postfix package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: postfix default
  Given a node named "class-postfix-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/postfix/main.cf"
  And there should be a file "/etc/postfix/master.cf"
  And there should be a file "/etc/mailname"
  And following directories should be created:
    | name                        |
    | /var/spool/postfix/var      |
    | /var/spool/postfix/var/run  |
  And following packages should be dealt with:
    | name  | state   |
    | postfix | latest  |
  And service "postfix" should be "running"

  Scenario: postfix removed
  Given a node named "class-postfix-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
  | name  | state   |
  | postfix | purged  |
  And there should be no resource "File[/etc/postfix/main.cf]"
  And there should be no resource "File[/etc/postfix/master.cf]"
  And there should be no resource "File[/etc/mailname]"
  And there should be no resource "File[/var/spool/postfix/var]"
  And there should be no resource "File[/var/spool/postfix/var/run]"
  And there should be no resource "Service[postfix]"
