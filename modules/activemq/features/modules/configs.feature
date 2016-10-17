Feature: activemq/configs.pp
  In order to manage activemq services on a system. This class must install the
  configs necessary for activemq to run.

    Scenario: activemq::config default
    Given a node named "class-activemq-configs-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/default/activemq" should be "present"
      And the file should contain "NO_START=0"
      And the file should contain /ACTIVEMQ_USER="activemq"/
      And the file should contain "DIETIME=2"
    And file "/usr/share/activemq/activemq-options" should be "present"
      And the file should contain "STARTTIME=5"
      And the file should contain /ACTIVEMQ_BASE="\/var\/lib\/activemq\/\$INSTANCE"/
      And the file should contain /JAVA_HOME="\/usr\/lib\/jvm\/java-6-openjdk\/"/
      And the file should contain /ACTIVEMQ_OPTS="-Xms512M -Xmx512M -Dorg.apache.activemq.UseDedicatedTaskRunner=true"/
      And the file should contain /ACTIVEMQ_ARGS="start xbean:activemq.xml"/

    Scenario: activemq::config from facts
    Given a node named "class-activemq-configs-default"
    And a fact "activemq_enabled" of "no"
    And a fact "activemq_user" of "foo"
    And a fact "activemq_dietime" of "3"
    And a fact "activemq_starttime" of "6"
    And a fact "activemq_base" of "/mnt/lib/activemq"
    And a fact "activemq_java_home" of "/opt/java6/"
    And a fact "activemq_min_heap" of "1024"
    And a fact "activemq_max_heap" of "1024"
    And a fact "activemq_args" of "start xbean:foo.xml"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/default/activemq" should be "present"
      And the file should contain "NO_START=1"
      And the file should contain /ACTIVEMQ_USER="foo"/
      And the file should contain "DIETIME=3"
    And file "/usr/share/activemq/activemq-options" should be "present"
      And the file should contain "STARTTIME=6"
      And the file should contain /ACTIVEMQ_BASE="\/mnt\/lib\/activemq"/
      And the file should contain /JAVA_HOME="\/opt\/java6\/"/
      And the file should contain /ACTIVEMQ_OPTS="-Xms1024M -Xmx1024M -Dorg.apache.activemq.UseDedicatedTaskRunner=true"/
      And the file should contain /ACTIVEMQ_ARGS="start xbean:foo.xml"/

    Scenario: activemq::config uninstalled
    Given a node named "class-activemq-configs-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/default/activemq" should be "absent"
    And file "/usr/share/activemq/activemq-options" should be "absent"
