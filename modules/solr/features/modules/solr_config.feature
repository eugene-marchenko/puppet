Feature: solr/config.pp
  In order to solror services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: solr::config default
    Given a node named "solr-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And exec "solr(mkdir -p /mnt/solr/data)" should be present
      And the exec should have a "command" of "install -o jetty -d /mnt/solr/data"
    And file "/var/lib/solr/data" should be "link"
      And the file should have a "target" of "/mnt/solr/data"
    And file "/usr/share/solr/data" should be "link"
      And the file should have a "target" of "/mnt/solr/data"

    Scenario: solr::config from facts
    Given a node named "solr-config-default"
    And a fact "solr_servlet_engine" of "tomcat"
    And a fact "solr_data_dir" of "/tmp/solr/data"
    And a fact "solr_data_dir_symlinks" of "/tmp/foo,/tmp/bar"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And exec "solr(mkdir -p /tmp/solr/data)" should be present
      And the exec should have a "command" of "install -o tomcat6 -d /tmp/solr/data"
    And file "/tmp/foo" should be "link"
      And the file should have a "target" of "/tmp/solr/data"
    And file "/tmp/bar" should be "link"
      And the file should have a "target" of "/tmp/solr/data"

    Scenario: solr::config no parameters
    Given a node named "solr-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
