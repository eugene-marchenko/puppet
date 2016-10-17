Feature: cron/init.pp
  In order to manage cron on a system. The cron class should by default
  install the cron package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: cron default
  Given a node named "class-cron-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/crontab" should be "present"
  And file "/etc/default/cron" should be "present"
  And following directories should be created:
    | name              |
    | /etc/cron.d       |
    | /etc/cron.hourly  |
    | /etc/cron.daily   |
    | /etc/cron.weekly  |
    | /etc/cron.monthly |
  And following packages should be dealt with:
    | name  | state   |
    | cron | latest  |
  And service "cron" should be "running"

  Scenario: cron removed
  Given a node named "class-cron-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
  | name  | state   |
  | cron | purged  |
  And there should be no resource "File[/etc/cron/cron.conf]"
  And there should be no resource "File[/etc/default/cron]"
  And there should be no resource "Service[cron]"
