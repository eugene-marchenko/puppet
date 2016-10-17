Feature: solr/init.pp
  In order to manage solr on a system. The solr class should by default
  install the solr package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

    Scenario: solr default
    Given a node named "class-solr-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And exec "solr(mkdir -p /mnt/solr/data)" should be present
    And file "/var/lib/solr/data" should be "link"
      And the file should have a "target" of "/mnt/solr/data"
    And file "/usr/share/solr/data" should be "link"
      And the file should have a "target" of "/mnt/solr/data"
    And following packages should be dealt with:
      | name        | state   |
      | solr-jetty  | latest  |

    Scenario: solr removed
    Given a node named "class-solr-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
    | name        | state   |
    | solr-jetty  | purged  |
    And there should be no resource "File[/var/lib/solr/data]"
    And there should be no resource "File[/usr/share/solr/data]"
