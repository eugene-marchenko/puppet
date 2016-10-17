Feature: sysctl/option.pp
  In order to configure sysctl options on a system. This define must take a
  sysctl option name, create a file, and then notify the Sysctl::Service.

    Scenario: sysctl::option net.core.rmem_max, with initscript
    Given a node named "sysctl-option-net.core.rmem_max"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/sysctl.d/60-net.core.rmem_max.conf"
      And the file should contain "net.core.rmem_max = 16777216"

    Scenario: sysctl::option with value and comment
    Given a node named "sysctl-option-value-comment"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/sysctl.d/60-net.ipv4.ip_local_port_range.conf"
      And the file should contain "# Per Varnish recommendations"
      And the file should contain "net.ipv4.ip_local_port_range = 1024 65535"
