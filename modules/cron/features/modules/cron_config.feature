Feature: cron/config.pp
  In order to cronor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: cron::config default
    Given a node named "cron-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/crontab" should be "present"
    And file "/etc/default/cron" should be "present"
      And the file should contain /READ_ENV="yes"/
      And the file should contain /#EXTRA_OPTS=""/
      And the file should contain /#CHECK_LOSTFOUND=no/
    And following directories should be created:
      | name              |
      | /etc/cron.d       |
      | /etc/cron.hourly  |
      | /etc/cron.daily   |
      | /etc/cron.weekly  |
      | /etc/cron.monthly |

    Scenario: cron::config from facts
    Given a node named "cron-config-from-facts"
    And a fact "cron_read_env" of "no"
    And a fact "cron_extra_opts" of "-L 5"
    And a fact "cron_check_lostfound" of "yes"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/crontab" should be "present"
    And file "/etc/default/cron" should be "present"
      And the file should contain /READ_ENV="no"/
      And the file should contain /EXTRA_OPTS="-L 5"/
      And the file should contain /CHECK_LOSTFOUND="yes"/
    And following directories should be created:
      | name              |
      | /etc/cron.d       |
      | /etc/cron.hourly  |
      | /etc/cron.daily   |
      | /etc/cron.weekly  |
      | /etc/cron.monthly |

    Scenario: cron::config no parameters
    Given a node named "cron-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
