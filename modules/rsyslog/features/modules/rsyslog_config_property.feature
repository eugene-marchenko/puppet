Feature: rsyslog/config/property.pp
  In order to configure rsyslog on a system. This define must create a file
  with the content specified.

    Scenario: rsyslog::config::property default
    Given a node named "rsyslog-config-property"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/rsyslog.d/54-all-errors-no-discard.conf"
      And the file should contain "# Let's grab all errors out to a specific log file but keep them for other filters"
      And the file should contain /^:msg, contains, "error" /var/log/error.log$/
    And there should be a file "/etc/rsyslog.d/55-varnish.conf"
      And the file should contain /^:syslogtag, contains, "\[varnishncsa\]" @syslog.example.com$/
      And the file should contain "& ~"

    Scenario: rsyslog::config::property no params
    Given a node named "rsyslog-config-property-no-params"
    When I try to compile the catalog
    Then compilation should fail
