Feature: sysctl/config.pp
  In order to sysctlor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: sysctl::config default
    Given a node named "sysctl-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/sysctl.conf"
    And following directories should be created:
      | name              |
      | /etc/sysctl.d |

    Scenario: sysctl::config no parameters
    Given a node named "sysctl-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
