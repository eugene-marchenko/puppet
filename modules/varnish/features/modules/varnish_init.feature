Feature: varnish/init.pp
  In order to manage varnish on a system. The varnish class should by default
  install the varnish package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: varnish default
  Given a node named "class-varnish-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/varnish/default.vcl"
  And there should be a file "/etc/varnish/devicedetect.vcl"
    And the file should not contain "android"
  And there should be a file "/etc/varnish/secret"
  And there should be a file "/etc/default/varnish"
  And there should be a file "/etc/default/varnishncsa"
  And there should be a file "/etc/default/varnishlog"
  And there should be a script "/etc/init.d/varnishncsa"
  And there should be a script "/etc/init.d/varnishlog"
  And file "/etc/logrotate.d/varnish" should be "absent"
  And exec "mkfifo /var/log/varnish/varnishncsa.log" should be present
  And there should be a restricted script "/usr/local/bin/varnish_restart.py"
  And exec "varnish-restart" should be present
  And following directories should be created:
    | name                |
    | /etc/varnish/errors |
  And following packages should be dealt with:
    | name          | state   |
    | varnish       | latest  |
    | libvmod-var   | latest  |
    | libvmod-curl  | latest  |
  And service "varnish" should be "running"

  Scenario: varnish logs from facts
  Given a node named "class-varnish-default"
  And a fact "varnish_ncsa_pipe_file" of "/tmp/varnishncsa.pipe"
  And a fact "varnish_ncsa_syslogtag" of "tag1"
  And a fact "varnish_mobile_detection" of "on"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/varnish/default.vcl"
  And there should be a file "/etc/varnish/devicedetect.vcl"
    And the file should contain "android"
  And there should be a file "/etc/varnish/secret"
  And there should be a file "/etc/default/varnish"
  And there should be a file "/etc/default/varnishncsa"
  And there should be a file "/etc/default/varnishlog"
  And there should be a script "/etc/init.d/varnishncsa"
    And the file should contain "LOGFILE=/tmp/varnishncsa.pipe"
    And the file should contain /LOGGER_DAEMON_OPTS="-t tag1/
  And there should be a script "/etc/init.d/varnishlog"
  And file "/etc/logrotate.d/varnish" should be "absent"
  And exec "mkfifo /tmp/varnishncsa.pipe" should be present
  And there should be a restricted script "/usr/local/bin/varnish_restart.py"
  And exec "varnish-restart" should be present
  And following directories should be created:
    | name                |
    | /etc/varnish/errors |
  And following packages should be dealt with:
    | name          | state   |
    | varnish       | latest  |
    | libvmod-var   | latest  |
    | libvmod-curl  | latest  |
  And service "varnish" should be "running"

  Scenario: varnish removed
  Given a node named "class-varnish-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
    | name          | state   |
    | varnish       | purged  |
    | libvmod-var   | purged  |
    | libvmod-curl  | purged  |
  And there should be no resource "File[/etc/varnish/default.vcl]"
  And there should be no resource "File[/etc/varnish/devicedetect.vcl]"
  And there should be no resource "File[/etc/default/varnish]"
  And there should be no resource "File[/etc/default/varnishncsa]"
  And there should be no resource "File[/etc/default/varnishlog]"
  And there should be no resource "File[/etc/init.d/varnishncsa]"
  And there should be no resource "Exec[mkfifo /var/log/varnish/varnishncsa.log]"
  And there should be no resource "File[/etc/init.d/varnishlog]"
  And there should be no resource "Exec[mkfifo /var/log/varnish/varnish.log]"
  And there should be no resource "File[/etc/logrotate.d/varnish]"
  And there should be no resource "File[/etc/varnish/errors]"
  And there should be no resource "File[/etc/varnish/errors/500.html]"
  And there should be no resource "Service[varnish]"
