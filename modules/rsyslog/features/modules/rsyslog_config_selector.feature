Feature: rsyslog/config/selector.pp
  In order to configure rsyslog on a system. This define must create a file
  with the content specified.

    Scenario: rsyslog::config::selector default
    Given a node named "rsyslog-config-selector"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/rsyslog.d/54-mail-no-discard.conf"
      And the file should contain "mail.* /var/log/mail.log"
    And there should be a file "/etc/rsyslog.d/55-catch-all.conf"
      And the file should contain "# This is the catch all for all non-discarded logs"
      And the file should contain "*.* /var/log/syslog"
      And the file should contain "*.* ~"

    Scenario: rsyslog::config::selector no params
    Given a node named "rsyslog-config-selector-no-params"
    When I try to compile the catalog
    Then compilation should fail
