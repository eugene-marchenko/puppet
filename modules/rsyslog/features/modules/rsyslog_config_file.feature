Feature: rsyslog/config/file.pp
  In order to configure rsyslog on a system. This define must create a file
  with the content specified.

    Scenario: rsyslog::config::file
    Given a node named "rsyslog-config-file"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/rsyslog.d/01-imuxsock.conf"
      And the file should contain /^\$ModLoad imuxsock/
    And there should be a file "/etc/rsyslog.d/02-imklog.conf"
      And the file should contain /^\$ModLoad imklog/

    Scenario: rsyslog::config::file no params
    Given a node named "rsyslog-config-file-no-params"
    When I try to compile the catalog
    Then compilation should fail
