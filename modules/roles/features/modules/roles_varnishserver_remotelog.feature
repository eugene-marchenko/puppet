Feature: roles/varnishserver/remotelog.pp
  In order to setup remote logging on a varnish cache server, this role must
  create the necessary resources to setup varnish remote loggin.

    Scenario: roles::varnish server remotelog
    Given a node named "class-roles-varnishserver-remotelog"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/rsyslog.d/37-varnish-remotelog.conf"
      And the file should contain /:syslogtag, contains, "\[varnishncsa\]" @syslog.ec2.thedailybeast.com/
      And the file should contain "& ~"

    Scenario: roles::varnish server remotelog tcp
    Given a node named "class-roles-varnishserver-remotelog"
    And a fact "varnish_syslog_remote_protocol" of "tcp"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/rsyslog.d/37-varnish-remotelog.conf"
      And the file should contain /:syslogtag, contains, "\[varnishncsa\]" @@syslog.ec2.thedailybeast.com/
      And the file should contain "& ~"

    Scenario: roles::varnish server remotelog relp specified
    Given a node named "class-roles-varnishserver-remotelog"
    And a fact "varnish_syslog_remote_protocol" of "relp"
    And a fact "rsyslog_modules" of "omrelp"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/rsyslog.conf"
      And the file should contain "$ModLoad omrelp"
    And there should be a file "/etc/rsyslog.d/37-varnish-remotelog.conf"
      And the file should contain /:syslogtag, contains, "\[varnishncsa\]" :omrelp:syslog.ec2.thedailybeast.com:2514/
      And the file should contain "& ~"

