Feature: roles/logserver/jenkins.pp
  In order to ship jenkins logs to a central log server this role is defined
  to create the resources necessary to do so.

    Scenario: roles::logserver::jenkins
    Given a node named "class-roles-logserver-jenkins"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::logserver]"
    And there should be a file "/etc/rsyslog.d/jenkins-slaves.conf"
      And the file should contain /# Slave logs/
      And the file should contain /$InputFileName /opt/jenkins/slave-Selenium.log/
      And the file should contain /$InputFileTag jenkins-slaves/
      And the file should contain /$InputFileStateFile jenkins-slaves-state/
      And the file should contain /$InputRunFileMonitor/
    And there should be a file "/etc/rsyslog.d/jenkins-audit.conf"
      And the file should contain /# Audit logs/
      And the file should contain /$InputFileName /opt/jenkins/audit.log/
      And the file should contain /$InputFileTag jenkins-audit/
      And the file should contain /$InputFileStateFile jenkins-audit-state/
      And the file should contain /$InputRunFileMonitor/
