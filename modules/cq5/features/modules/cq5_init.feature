Feature: cq5/init.pp
  In order to manage cq5 on a system. The cq5 class should by default
  install the cq5 package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

    Scenario: cq5 default
    Given a node named "class-cq5-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a script "/usr/local/bin/create_support_files.sh"
    And there should be a script "/usr/local/bin/vlt_copy.sh"
    And there should be a script "/usr/local/bin/crx_restart.py"

    Scenario: cq5 removed
    Given a node named "class-cq5-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/usr/local/bin/create_support_files.sh" should be "absent"
    And file "/usr/local/bin/vlt_copy.sh" should be "absent"
    And file "/usr/local/bin/crx_restart.py" should be "absent"
