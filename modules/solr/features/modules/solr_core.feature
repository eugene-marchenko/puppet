Feature: solr/core.pp
  In order to manage solr cores on a system. The solr core define should allow
  the creation of multiple named cores. It should ensure solr is installed,
  ensure that the named core's instance and data directories are created, setup
  necessary symlinks, and restart the appropriate servlet container.

    Scenario: solr core 1 core
    Given a node named "solr-core-1-core"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And exec "solr::core::core0(mkdir -p /usr/share/solr/core0)" should be present
    And exec "solr::core::core0(mkdir -p /mnt/solr/data/core0)" should be present
    And file "/usr/share/solr/core0/conf" should be "link"
      And the file should have a "target" of "/etc/solr/conf"
    And file "/usr/share/solr/solr.xml" should be "present"

    Scenario: solr core multiple cores
    Given a node named "solr-core-multiple-cores"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And exec "solr::core::core0(mkdir -p /usr/share/solr/core0)" should be present
    And exec "solr::core::core0(mkdir -p /mnt/solr/data/core0)" should be present
    And file "/usr/share/solr/core0/conf" should be "link"
      And the file should have a "target" of "/etc/solr/conf"
    And exec "solr::core::core1(mkdir -p /usr/share/solr/core1)" should be present
    And exec "solr::core::core1(mkdir -p /mnt/solr/data/core1)" should be present
    And file "/usr/share/solr/core1/conf" should be "link"
      And the file should have a "target" of "/etc/solr/conf"
    And file "/usr/share/solr/solr.xml" should be "present"

    Scenario: solr core from facts
    Given a node named "solr-core-1-core"
    And a fact "solr_home" of "/opt/solr"
    And a fact "solr_conf_dir" of "/opt/solr/conf"
    And a fact "solr_data_dir" of "/data/solr"
    And a fact "solr_cores_config" of "/tmp/solr.xml"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And exec "solr::core::core0(mkdir -p /opt/solr/core0)" should be present
    And exec "solr::core::core0(mkdir -p /data/solr/core0)" should be present
    And file "/opt/solr/core0/conf" should be "link"
      And the file should have a "target" of "/opt/solr/conf"
    And file "/tmp/solr.xml" should be "present"

    Scenario: solr core with parameters set
    Given a node named "solr-core-with-parameters"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And exec "solr::core::core0(mkdir -p /data/solr/core0)" should be present
    And exec "solr::core::core0(mkdir -p /data/solr/core0/data)" should be present
    And file "/data/solr/core0/conf" should be "link"
      And the file should have a "target" of "/etc/solr/conf"
    And file "/usr/share/solr/solr.xml" should be "present"
