Feature: roles/logserver/varnish.pp
  In order to ship varnish logs to a central log server this role is defined
  to create the resources necessary to do so.

    Scenario: roles::logserver::varnish
    Given a node named "class-roles-logserver-varnish"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::logserver]"
    And there should be a file "/etc/rsyslog.d/07-ncsa-template.conf"
      And the file should contain /\$template NCSA,"%msg:2:\$%\\n"\n/
    And there should be a file "/etc/rsyslog.d/35-varnish-remote-logs-ncsa.conf"
      And the file should contain /:syslogtag, contains, "varnishncsa" \/var\/log\/remotelogs\/varnish\/varnishncsa.log;NCSA/
    And there should be a file "/etc/rsyslog.d/36-varnish-remote-logs.conf"
      And the file should contain /:syslogtag, contains, "varnishncsa" \/var\/log\/remotelogs\/varnish\/varnish-syslog-traditional.log/
      And the file should contain "& ~"
    And there should be a file "/etc/logrotate.d/varnish-remote-syslog"
      And the file should contain "/var/log/remotelogs/varnish/varnishncsa.log /var/log/remotelogs/varnish/varnish-syslog-traditional.log {"
      And the file should contain "  compress"
      And the file should contain "  missingok"
      And the file should contain "  daily"
      And the file should contain "  rotate 90"
      And the file should contain /  postrotate\n    reload rsyslog >\/dev\/null 2>&1 || true\n  endscript\n\}/

    Scenario: roles::logserver::varnish from facts
    Given a node named "class-roles-logserver-varnish"
    And a fact "remote_log_directory" of "/d0/logs"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::logserver]"
    And there should be a file "/etc/rsyslog.d/07-ncsa-template.conf"
      And the file should contain /\$template NCSA,"%msg:2:\$%\\n"\n/
    And there should be a file "/etc/rsyslog.d/35-varnish-remote-logs-ncsa.conf"
      And the file should contain /:syslogtag, contains, "varnishncsa" \/d0\/logs\/varnish\/varnishncsa.log;NCSA/
    And there should be a file "/etc/rsyslog.d/36-varnish-remote-logs.conf"
      And the file should contain /:syslogtag, contains, "varnishncsa" \/d0\/logs\/varnish\/varnish-syslog-traditional.log/
      And the file should contain "& ~"
    And there should be a file "/etc/logrotate.d/varnish-remote-syslog"
      And the file should contain "/d0/logs/varnish/varnishncsa.log /d0/logs/varnish/varnish-syslog-traditional.log {"
      And the file should contain "  compress"
      And the file should contain "  missingok"
      And the file should contain "  daily"
      And the file should contain "  rotate 90"
      And the file should contain /  postrotate\n    reload rsyslog >\/dev\/null 2>&1 || true\n  endscript\n\}/
