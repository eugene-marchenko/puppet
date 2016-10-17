Feature: build/config.pp
  In order to manage build services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: build::config default
    Given a node named "build-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/root/README.Debian" should be "present"

    Scenario: build::config no parameters
    Given a node named "build-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
