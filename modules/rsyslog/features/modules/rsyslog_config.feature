Feature: rsyslog/config.pp
  In order to rsyslogor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: rsyslog::config default
    Given a node named "rsyslog-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/rsyslog.conf"
      And the file should contain /^\$ModLoad imuxsock/
      And the file should contain /^\$ModLoad imklog/
      And the file should contain /^#\$ModLoad imudp/
      And the file should contain /^#\$UDPServerRun 514/
      And the file should contain /^#\$ModLoad imtcp/
      And the file should contain /^#\$InputTCPServerRun 514/
      And the file should contain /^#\$ModLoad imrelp/
      And the file should contain /^#\$InputRELPServerRun 2514/
      And the file should contain /^\$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat/
      And the file should contain /^\$RepeatedMsgReduction on/
      And the file should contain /^\$FileOwner syslog/
      And the file should contain /^\$FileGroup adm/
      And the file should contain /^\$FileCreateMode 0640/
      And the file should contain /^\$DirCreateMode 0755/
      And the file should contain /^\$Umask 0022/
      And the file should contain /^\$PrivDropToUser syslog/
      And the file should contain /^\$PrivDropToGroup syslog/
      And the file should contain /^\$WorkDirectory /var/spool/rsyslog/
      And the file should contain /^\$IncludeConfig /etc/rsyslog\.d/\*\.conf/
    And there should be a file "/etc/default/rsyslog"
      And the file should contain /RSYSLOGD_OPTIONS="-c5"/
    And there should be a file "/etc/rsyslog.d/50-default.conf"
    And following directories should be created:
      | name            |
      | /etc/rsyslog.d  |

    Scenario: rsyslog::config from facts
    Given a node named "rsyslog-config-default"
    And a fact "rsyslog_options" of "-r -c3"
    And a fact "rsyslog_modules" of "imuxsock,imklog,immark"
    And a fact "rsyslog_udp_enabled" of "yes"
    And a fact "rsyslog_tcp_enabled" of "yes"
    And a fact "rsyslog_relp_enabled" of "yes"
    And a fact "rsyslog_high_precision_timestamps" of "yes"
    And a fact "rsyslog_message_reduction" of "off"
    And a fact "rsyslog_file_owner" of "rsyslog"
    And a fact "rsyslog_file_group" of "rsyslog"
    And a fact "rsyslog_file_createmode" of "0644"
    And a fact "rsyslog_dir_createmode" of "0750"
    And a fact "rsyslog_umask" of "0002"
    And a fact "rsyslog_priv_droptouser" of "rsyslog"
    And a fact "rsyslog_priv_droptogroup" of "rsyslog"
    And a fact "rsyslog_spool_dir" of "/tmp"
    And a fact "rsyslog_include_conf" of "/etc/rsyslog-varnish.conf"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/rsyslog.conf"
      And the file should contain /^\$ModLoad imuxsock/
      And the file should contain /^\$ModLoad imklog/
      And the file should contain /^\$ModLoad immark/
      And the file should contain /^\$ModLoad imudp/
      And the file should contain /^\$UDPServerRun 514/
      And the file should contain /^\$ModLoad imtcp/
      And the file should contain /^\$InputTCPServerRun 514/
      And the file should contain /^\$ModLoad imrelp/
      And the file should contain /^\$InputRELPServerRun 2514/
      And the file should contain /^#\$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat/
      And the file should contain /^\$RepeatedMsgReduction off/
      And the file should contain /^\$FileOwner rsyslog/
      And the file should contain /^\$FileGroup rsyslog/
      And the file should contain /^\$FileCreateMode 0644/
      And the file should contain /^\$DirCreateMode 0750/
      And the file should contain /^\$Umask 0002/
      And the file should contain /^\$PrivDropToUser rsyslog/
      And the file should contain /^\$PrivDropToGroup rsyslog/
      And the file should contain /^\$WorkDirectory /tmp/
      And the file should contain /^\$IncludeConfig /etc/rsyslog-varnish\.conf/
    And there should be a file "/etc/default/rsyslog"
      And the file should contain /RSYSLOGD_OPTIONS="-r -c3"/
    And there should be a file "/etc/rsyslog.d/50-default.conf"
    And following directories should be created:
      | name            |
      | /etc/rsyslog.d  |

    Scenario: rsyslog::config no parameters
    Given a node named "rsyslog-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
