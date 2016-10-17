Feature: rsyslog/init.pp
  In order to manage rsyslog on a system. The rsyslog class should by default
  install the rsyslog package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: rsyslog default
  Given a node named "class-rsyslog-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/rsyslog.conf"
    And the file should contain "$ModLoad imuxsock"
    And the file should contain "$ModLoad imklog"
  And there should be a file "/etc/default/rsyslog"
  And file "/etc/rsyslog.d/50-default.conf" should be "present"
  And following directories should be created:
    | name            |
    | /etc/rsyslog.d  |
  And following packages should be dealt with:
    | name          | state   |
    | rsyslog       | latest  |
    | rsyslog-doc   | latest  |
    | rsyslog-relp  | latest  |
  And service "rsyslog" should be "running"

  Scenario: rsyslog default from facts
  Given a node named "class-rsyslog-default"
  And a fact "rsyslog_modules" of "immark"
  And a fact "syslog_remote_protocol" of "relp"
  And a fact "rsyslog_high_precision_timestamps" of "no"
  And a fact "rsyslog_enable_udp" of "yes"
  And a fact "rsyslog_enable_tcp" of "no"
  And a fact "rsyslog_enable_relp" of "no"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/rsyslog.conf"
    And the file should contain "$ModLoad imuxsock"
    And the file should contain "$ModLoad imklog"
    And the file should contain "$ModLoad immark"
    And the file should contain "$ModLoad omrelp"
    And the file should contain "$ModLoad imudp"
    And the file should contain "$UDPServerRun 514"
    And the file should contain "#$ModLoad imtcp"
    And the file should contain "#$InputTCPServerRun 514"
    And the file should contain "#$ModLoad imrelp"
    And the file should contain "#$InputRELPServerRun 2514"
  And there should be a file "/etc/default/rsyslog"
  And file "/etc/rsyslog.d/50-default.conf" should be "present"
  And following directories should be created:
    | name            |
    | /etc/rsyslog.d  |
  And following packages should be dealt with:
    | name          | state   |
    | rsyslog       | latest  |
    | rsyslog-doc   | latest  |
    | rsyslog-relp  | latest  |
  And service "rsyslog" should be "running"

  Scenario: rsyslog example use with varnish remote logging
  Given a node named "class-rsyslog-example-use-with-varnish"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/rsyslog.conf"
  And there should be a file "/etc/default/rsyslog"
  And following directories should be created:
    | name            |
    | /etc/rsyslog.d  |
  And there should be a file "/etc/rsyslog.d/50-default.conf"
  And there should be a file "/etc/rsyslog.d/40-varnish.conf"
    And the file should contain /:syslogtag, contains, "\[varnishncsa\]" @syslog.example.com/
    And the file should contain "& ~"
  And following packages should be dealt with:
    | name          | state |
    | rsyslog       | latest  |
    | rsyslog-doc   | latest  |
    | rsyslog-relp  | latest  |
  And service "rsyslog" should be "running"

  Scenario: rsyslog removed
  Given a node named "class-rsyslog-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
  | name          | state   |
  | rsyslog       | purged  |
  | rsyslog-doc   | purged  |
  | rsyslog-relp  | purged  |
  And there should be no resource "File[/etc/rsyslog.conf]"
  And there should be no resource "File[/etc/default/rsyslog]"
  And there should be no resource "File[/etc/rsyslog.d]"
  And there should be no resource "File[/etc/rsyslog.d/50-default.conf]"
  And there should be no resource "Service[rsyslog]"

  Scenario: rsyslog central logging varnish example
  Given a node named "class-rsyslog-server-central-logging-varnish-example"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/rsyslog.conf"
    And the file should contain "$ModLoad imudp"
    And the file should contain "$UDPServerRun 514"
  And there should be a file "/etc/default/rsyslog"
  And following directories should be created:
    | name            |
    | /etc/rsyslog.d  |
  And there should be a file "/etc/rsyslog.d/50-default.conf"
  And there should be a file "/etc/rsyslog.d/39-varnish-ncsa.conf"
    And the file should contain /:syslogtag, contains, "\[varnishncsa\]" /d0/logs/varnish/varnishncsa.log;NCSA/
  And there should be a file "/etc/rsyslog.d/40-varnish.conf"
    And the file should contain /:syslogtag, contains, "\[varnishncsa\]" /d0/logs/varnish/varnish-syslog-traditional.log/
    And the file should contain "& ~"
  And following packages should be dealt with:
    | name    | state |
    | rsyslog | latest  |
  And service "rsyslog" should be "running"

