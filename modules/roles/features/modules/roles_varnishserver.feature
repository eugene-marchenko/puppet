Feature: roles/varnishserver.pp
  In order to setup a varnish cache server, this role must create the necessary
  resources to setup varnish, tune the system, and setup necessary files.

    Scenario: roles::varnish server
    Given a node named "class-roles-varnishserver"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::backports]"
    And there should be a resource "Exec[varnishserver(mkdir -p /var/lib/varnish)]"
    And there should be a resource "Class[varnish]"
    And there should be a resource "Package[python-varnish]"
    And there should be a file "/etc/logrotate.d/varnish-syslog"
    And there should be a file "/etc/monit/conf.d/varnishd"
    And there should be a file "/etc/rsyslog.d/06-ncsa-template.conf"
    And there should be a file "/etc/rsyslog.d/08-rate-limiting.conf"
      And the file should contain /\$SystemLogRateLimitInterval 10\n\$SystemLogRateLimitBurst 5000\n/
    And there should be a file "/etc/rsyslog.d/38-varnish-ncsa-log.conf"
    And there should be a file "/etc/rsyslog.d/39-varnish-log.conf"
    And there should be a file "/etc/sysctl.d/60-net.core.netdev_max_backlog.conf"
    And there should be a file "/etc/sysctl.d/60-net.core.rmem_max.conf"
    And there should be a file "/etc/sysctl.d/60-net.core.somaxconn.conf"
    And there should be a file "/etc/sysctl.d/60-net.core.wmem_max.conf"
    And there should be a file "/etc/sysctl.d/60-net.ipv4.ip_local_port_range.conf"
    And there should be a file "/etc/sysctl.d/60-net.ipv4.tcp_fin_timeout.conf"
    And there should be a file "/etc/sysctl.d/60-net.ipv4.tcp_max_orphans.conf"
    And there should be a file "/etc/sysctl.d/60-net.ipv4.tcp_max_syn_backlog.conf"
    And there should be a file "/etc/sysctl.d/60-net.ipv4.tcp_no_metrics_save.conf"
    And there should be a file "/etc/sysctl.d/60-net.ipv4.tcp_rmem.conf"
    And there should be a file "/etc/sysctl.d/60-net.ipv4.tcp_syncookies.conf"
    And there should be a file "/etc/sysctl.d/60-net.ipv4.tcp_wmem.conf"
    And there should be a file "/etc/sysctl.d/60-net.ipv4.tcp_synack_retries.conf"
    And there should be a file "/etc/sysctl.d/60-net.ipv4.tcp_syn_retries.conf"

    Scenario: roles::varnish server from facts
    Given a node named "class-roles-varnishserver"
    And a fact "varnish_storage_file" of "/mnt/varnish/varnish_storage.bin"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Exec[varnishserver(mkdir -p /mnt/varnish)]"

