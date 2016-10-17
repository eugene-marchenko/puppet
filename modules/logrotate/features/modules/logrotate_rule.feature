Feature: logrotate/rule.pp
  In order to rotate logfiles on a system. This define must take a list of
  log files to rotate and optional logrotate options and create the necessary
  logrotate rule file to rotate those log files.

    Scenario: logrotate::rule rotate weekly
    Given a node named "logrotate-rule-rotate-weekly"
    When I compile the catalog
    Then compilation should succeed

    Scenario: logrotate::rule no params
    Given a node named "logrotate-rule-no-params"
    When I try to compile the catalog
    Then compilation should fail 

    Scenario: logrotate::rule every param
    Given a node named "logrotate-rule-every-param"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/logrotate.d/web-server"
      And the file should contain "/var/log/web-server-error.log /var/log/web-server.log {"
      And the file should contain "  create 0644 root root"
      And the file should contain "  compress"
      And the file should contain "  copy"
      And the file should contain "  copytruncate"
      And the file should contain "  delaycompress"
      And the file should contain "  dateext"
      And the file should contain "  mail sa@example.com"
      And the file should contain "  missingok"
      And the file should contain "  olddir old"
      And the file should contain "  sharedscripts"
      And the file should contain "  ifempty"
      And the file should contain "  mailfirst"
      And the file should contain "  shred"
      And the file should contain "  daily"
      And the file should contain "  compresscmd /bin/gzip"
      And the file should contain "  compressext foo"
      And the file should contain "  compressoptions -9"
      And the file should contain "  dateformat YYYYmmdd"
      And the file should contain "  extension foo"
      And the file should contain "  maxage 90"
      And the file should contain "  minsize 1G"
      And the file should contain "  rotate 7"
      And the file should contain "  size 1G"
      And the file should contain "  shredcycles 2"
      And the file should contain "  start 1"
      And the file should contain "  uncompresscmd gunzip"
      And the file should contain "  postrotate"
      And the file should contain "    reload web-server"
      And the file should contain "  endscript"
      And the file should contain "  prerotate"
      And the file should contain "    run-parts /etc/logrotate.d/web-server-prerotate"
      And the file should contain "  endscript"
      And the file should contain "  firstaction"
      And the file should contain /^    echo "Starting log rotation" > /tmp/foo$/
      And the file should contain "  endscript"
      And the file should contain "  lastaction"
      And the file should contain /^    echo "Completed log rotation" > /tmp/foo$/
      And the file should contain "  endscript"
      And the file should contain "}"
    And there should be a file "/etc/logrotate.d/web-server2"
      And the file should contain "/var/log/web-server-error2.log /var/log/web-server2.log {"
      And the file should contain "  nocompress"
      And the file should contain "  nocopy"
      And the file should contain "  nocopytruncate"
      And the file should contain "  nodelaycompress"
      And the file should contain "  nodateext"
      And the file should contain "  mail sa@example.com"
      And the file should contain "  nomissingok"
      And the file should contain "  olddir old"
      And the file should contain "  nosharedscripts"
      And the file should contain "  notifempty"
      And the file should contain "  noshred"
      And the file should contain "  daily"
      And the file should contain "  compresscmd /bin/gzip"
      And the file should contain "  compressext foo"
      And the file should contain "  compressoptions -9"
      And the file should contain "  dateformat YYYYmmdd"
      And the file should contain "  extension foo"
      And the file should contain "  maxage 90"
      And the file should contain "  minsize 1G"
      And the file should contain "  rotate 7"
      And the file should contain "  size 1G"
      And the file should contain "  shredcycles 2"
      And the file should contain "  start 1"
      And the file should contain "  uncompresscmd gunzip"
      And the file should contain "  postrotate"
      And the file should contain "    reload web-server"
      And the file should contain "  endscript"
      And the file should contain "  prerotate"
      And the file should contain "    run-parts /etc/logrotate.d/web-server-prerotate"
      And the file should contain "  endscript"
      And the file should contain "  firstaction"
      And the file should contain /^    echo "Starting log rotation" > /tmp/foo$/
      And the file should contain "  endscript"
      And the file should contain "  lastaction"
      And the file should contain /^    echo "Completed log rotation" > /tmp/foo$/
      And the file should contain "  endscript"
      And the file should contain "}"

    Scenario: logrotate::rule invalid namevar
    Given a node named "logrotate-rule-invalid-namevar"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid compress 
    Given a node named "logrotate-rule-invalid-compress"
    When I try to compile the catalog
    Then compilation should fail 

    Scenario: logrotate::rule invalid copy 
    Given a node named "logrotate-rule-invalid-copy"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid copytruncate 
    Given a node named "logrotate-rule-invalid-copytruncate"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid create 
    Given a node named "logrotate-rule-invalid-create"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid delaycompress
    Given a node named "logrotate-rule-invalid-delaycompress"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid dateext 
    Given a node named "logrotate-rule-invalid-dateext"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid missingok
    Given a node named "logrotate-rule-invalid-missingok"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid sharedscripts
    Given a node named "logrotate-rule-invalid-sharedscripts"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid shred
    Given a node named "logrotate-rule-invalid-shred"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid ifempty
    Given a node named "logrotate-rule-invalid-ifempty"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid rotate_every 
    Given a node named "logrotate-rule-invalid-rotate_every"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid maxage 
    Given a node named "logrotate-rule-invalid-maxage"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid minsize
    Given a node named "logrotate-rule-invalid-minsize"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid rotate
    Given a node named "logrotate-rule-invalid-rotate"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid size
    Given a node named "logrotate-rule-invalid-size"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid shredcycles
    Given a node named "logrotate-rule-invalid-shredcycles"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid start
    Given a node named "logrotate-rule-invalid-start"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid mailfirst
    Given a node named "logrotate-rule-invalid-mailfirst"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid create_group
    Given a node named "logrotate-rule-invalid-create_group"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid create_owner
    Given a node named "logrotate-rule-invalid-create_owner"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: logrotate::rule invalid create_mode
    Given a node named "logrotate-rule-invalid-create_mode"
    When I try to compile the catalog
    Then compilation should fail

