Feature: roles/logserver.pp
  In order to setup a central log server, this role must create the necessary
  resources to accept remote logs and store them.

    Scenario: roles::logserver 
    Given a node named "class-roles-logserver"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Exec[logserver(mkdir -p /var/log/remotelogs)]"
    And there should be a resource "Mount[/var/log/remotelogs]"
      And the resource should have an "ensure" of "mounted"
      And the resource should have a "device" of "/dev/mapper/syslog--data-vol01"
      And the resource should have an "fstype" of "xfs"
      And the resource should have an "options" of "defaults"
    And there should be a file "/etc/rsyslog.d/05-dyna-template.conf"
      And the file should contain /\$template DynaFile,"\/var\/log\/remotelogs\/system-%HOSTNAME%.log"/
    And there should be a file "/etc/rsyslog.d/49-remote-logs.conf"
      And the file should contain /:hostname, !isequal, "class-roles-logserver" -\?DynaFile/
      And the file should contain "& ~"
    And there should be a file "/etc/logrotate.d/remotelogs"
      And the file should contain "/var/log/remotelogs/*.log {"
      And the file should contain "  compress"
      And the file should contain "  missingok"
      And the file should contain "  daily"
      And the file should contain "  rotate 30"
      And the file should contain /  postrotate\n    reload rsyslog >\/dev\/null 2>&1 || true\n  endscript\n\}/

    Scenario: roles::logserver from facts
    Given a node named "class-roles-logserver"
    And a fact "remote_log_directory" of "/mnt/logs"
    And a fact "logserver_mount_device" of "/dev/sdj"
    And a fact "logserver_mount_fstype" of "ext3"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Exec[logserver(mkdir -p /mnt/logs)]"
    And there should be a resource "Mount[/mnt/logs]"
      And the resource should have an "ensure" of "mounted"
      And the resource should have a "device" of "/dev/sdj"
      And the resource should have an "fstype" of "ext3"
      And the resource should have an "options" of "defaults"
    And there should be a file "/etc/rsyslog.d/05-dyna-template.conf"
      And the file should contain /\$template DynaFile,"\/mnt\/logs\/system-%HOSTNAME%.log"/
    And there should be a file "/etc/rsyslog.d/49-remote-logs.conf"
      And the file should contain /:hostname, !isequal, "class-roles-logserver" -\?DynaFile/
      And the file should contain "& ~"
    And there should be a file "/etc/logrotate.d/remotelogs"
      And the file should contain "/mnt/logs/*.log {"
      And the file should contain "  compress"
      And the file should contain "  missingok"
      And the file should contain "  daily"
      And the file should contain "  rotate 30"
      And the file should contain /  postrotate\n    reload rsyslog >\/dev\/null 2>&1 || true\n  endscript\n\}/
