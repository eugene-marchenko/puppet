Feature: monit/monitor/service.pp
  In order to monitor services on a system. This define must take a service
  name and create a service monitor for it.

    Scenario: monit::monitor::service puppet, with initscript
    Given a node named "monit-monitor-service-puppet"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/monit/conf.d/puppetd"
      And the file should contain "/etc/init.d/puppet start"
      And the file should contain "/var/run/puppetd/puppetd.pid"
