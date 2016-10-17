Feature: nw_analytics/init.pp
  In order to manage nw_analytics on a system. The nw_analytics class should by default
  install the nw_analytics package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: nw_analytics default
  Given a node named "class-nw_analytics-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/nw-analytics/nwdb-analytics.properties" should be "present"
  And following packages should be dealt with:
    | name          | state   |
    | nw-analytics  | latest  |

  Scenario: nw_analytics removed
  Given a node named "class-nw_analytics-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
  | name          | state   |
  | nw-analytics  | purged  |
  And there should be no resource "File[/etc/nw-analytics/nwdb-analytics.properties]"
