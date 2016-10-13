Feature: roles/remotelog.pp
  In order to ship logs to a central log server this role is defined
  to create the resources necessary to do so.

    Scenario: roles::remotelog
    Given a node named "class-roles-remotelog"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::base]"
    And there should be a resource "Class[roles::remotelog]"
    And there should be a file "/etc/rsyslog.d/55-catch-all.conf"
      And the file should contain "$template enhanced,"{\"event\":{\"p_proc\":\"%programname%\",\"p_sys\":\"%hostname%\",\"time\":\"%timestamp:::date-rfc3339%\"},\"message\":{\"raw_msg\":\"%rawmsg%\"}}\n",json"
      And the file should contain "*.* @syslog.ec2.thedailybeast.com;enhanced"

    Scenario: roles::remotelog from facts
    Given a node named "class-roles-remotelog"
    And a fact "syslog_server" of "localhost"
    And a fact "syslog_remote_protocol" of "relp"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::base]"
    And there should be a resource "Class[roles::remotelog]"
    And there should be a file "/etc/rsyslog.d/55-catch-all.conf"
      And the file should contain "$template enhanced,"{\"event\":{\"p_proc\":\"%programname%\",\"p_sys\":\"%hostname%\",\"time\":\"%timestamp:::date-rfc3339%\"},\"message\":{\"raw_msg\":\"%rawmsg%\"}}\n",json"
      And the file should contain "*.* :omrelp:localhost:2514;enhanced"
