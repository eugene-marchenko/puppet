Feature: logrotate/config.pp
  In order to logrotateor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: logrotate::config default
    Given a node named "logrotate-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/logrotate.conf" should be "present"
    And there should be a script "/etc/cron.daily/logrotate"
    And following directories should be created:
      | name              |
      | /etc/logrotate.d  |

    Scenario: logrotate::config no parameters
    Given a node named "logrotate-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
