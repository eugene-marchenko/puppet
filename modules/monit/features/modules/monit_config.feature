Feature: monit/config.pp
  In order to monitor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: monit::config default
    Given a node named "monit-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/monit/monitrc" should be "present"
      And the file should contain "set daemon 120"
      And the file should contain "include /etc/monit/conf.d/* # Modified by puppet"
    And file "/etc/default/monit" should be "present"
      And the file should contain "#MONIT_OPTS="
    And following directories should be created:
      | name              |
      | /etc/monit/conf.d |

    Scenario: monit::config from facts
    Given a node named "monit-config-from-facts"
    And a fact "monit_daemon_interval" of "180"
    And a fact "monit_opts" of "-d 180"
    And a fact "monit_dot_dir" of "/etc/monit.d"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/monit/monitrc" should be "present"
      And the file should contain "set daemon 180"
      And the file should contain "include /etc/monit.d/* # Modified by puppet"
    And file "/etc/default/monit" should be "present"
      And the file should contain /MONIT_OPTS=\"-d 180\"/
    And following directories should be created:
      | name              |
      | /etc/monit.d |

    Scenario: monit::config no parameters
    Given a node named "monit-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
