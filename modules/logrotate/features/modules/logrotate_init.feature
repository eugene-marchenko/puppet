Feature: logrotate/init.pp
  In order to manage logrotate on a system. The logrotate class should by default
  install the logrotate package and any necessary files and or directories.
  It should provide an ability to remove itself as well.

  Scenario: logrotate default
  Given a node named "class-logrotate-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/logrotate.conf" should be "present"
  And there should be a script "/etc/cron.daily/logrotate"
  And following directories should be created:
    | name              |
    | /etc/logrotate.d  |
  And following packages should be dealt with:
    | name      | state   |
    | logrotate | latest  |

  Scenario: logrotate removed
  Given a node named "class-logrotate-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
  | name      | state   |
  | logrotate | purged  |
  And there should be no resource "File[/etc/logrotate.conf]"
  And there should be no resource "File[/etc/logrotate.d]"
  And there should be no resource "File[/etc/cron.daily/logrotate]"
  And there should be no resource "Service[logrotate]"
