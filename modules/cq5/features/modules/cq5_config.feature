Feature: cq5/config.pp
  In order to install cq5 on a system. This define must take a hash of
  configs to install and create them.

    Scenario: cq5::config default
    Given a node named "cq5-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a script "/usr/local/bin/create_support_files.sh"
    And there should be a script "/usr/local/bin/vlt_copy.sh"
    And there should be a script "/usr/local/bin/crx_restart.py"

    Scenario: cq5::config no parameters
    Given a node named "cq5-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
