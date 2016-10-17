Feature: ntp/configs.pp
  In order to manage ntp services on a system. This class must install the
  configs necessary for ntp to run.

    Scenario: ntp::config default
    Given a node named "class-ntp-configs-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/default/ntp" should be "present"
      And the file should contain "NTPD_OPTS='-g'"
    And file "/etc/ntp.conf" should be "present"
      And the file should contain "driftfile /var/lib/ntp/ntp.drift"
      And the file should contain "#statsdir /var/log/ntpstats/"
      And the file should contain "server 0.ubuntu.pool.ntp.org"
      And the file should contain "server 1.ubuntu.pool.ntp.org"
      And the file should contain "server 2.ubuntu.pool.ntp.org"
      And the file should contain "server 3.ubuntu.pool.ntp.org"
      And the file should contain "server ntp.ubuntu.com"

    Scenario: ntp::config from facts
    Given a node named "class-ntp-configs-default"
    And a fact "ntp_opts" of "-v"
    And a fact "ntp_driftfile" of "/tmp/ntp.drift"
    And a fact "ntp_statsdir" of "/tmp/ntpstats"
    And a fact "ntp_servers" of "ntp.foo.com,ntp.bar.com"
    And a fact "ntp_server_fallback" of "baz.qux.com"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/default/ntp" should be "present"
      And the file should contain "NTPD_OPTS='-v'"
    And file "/etc/ntp.conf" should be "present"
      And the file should contain "driftfile /tmp/ntp.drift"
      And the file should contain "statsdir /tmp/ntpstats"
      And the file should contain "server ntp.foo.com"
      And the file should contain "server ntp.bar.com"
      And the file should not contain "server 2.ubuntu.pool.ntp.org"
      And the file should contain "server baz.qux.com"

    Scenario: ntp::config uninstalled
    Given a node named "class-ntp-configs-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/default/ntp" should be "absent"
    And file "/etc/ntp.conf" should be "absent"
