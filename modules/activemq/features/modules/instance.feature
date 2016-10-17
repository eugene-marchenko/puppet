Feature: activemq/instance.pp
  In order to manage separate activemq instances on a system. The instance class
  should create the necessary instance directory, instance configs within that
  directory and manage whether the instance is enabled or not. It should have
  a method for removing itself as well.

  Scenario: activemq::instance test
  Given a node named "activemq-instance-test"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a resource "Activemq::Instance[foo]"
  And there should be a file "/etc/activemq/instances-available/foo/activemq.xml"
  And there should be a file "/etc/activemq/instances-available/foo/log4j.properties"
  And there should be a file "/etc/activemq/instances-available/foo/options"
    And the file should contain "STARTTIME=5"
    And the file should contain /ACTIVEMQ_BASE="\/var\/lib\/activemq\/\$INSTANCE"/
    And the file should contain /JAVA_HOME="\/usr\/lib\/jvm\/java-6-openjdk\/"/
    And the file should contain /ACTIVEMQ_OPTS="-Xms512M -Xmx512M -Dorg.apache.activemq.UseDedicatedTaskRunner=true"/
    And the file should contain /ACTIVEMQ_ARGS="start xbean:activemq.xml"/
  And file "/etc/activemq/instances-enabled/foo" should be "link"
  And following directories should be created:
    | name                                  |
    | /etc/activemq/instances-available/foo |

  And there should be a resource "Activemq::Instance[bar]"
  And there should be a file "/etc/activemq/instances-available/bar/activemq.xml"
  And there should be a file "/etc/activemq/instances-available/bar/log4j.properties"
  And there should be a file "/etc/activemq/instances-available/bar/options"
  And file "/etc/activemq/instances-enabled/bar" should be "absent"
  And following directories should be created:
    | name                                  |
    | /etc/activemq/instances-available/bar |

  And there should be a resource "Activemq::Instance[baz]"
  And file "/etc/activemq/instances-available/baz" should be "absent"
  And file "/etc/activemq/instances-available/baz/activemq.xml" should be "absent"
  And file "/etc/activemq/instances-available/baz/log4j.properties" should be "absent"
  And file "/etc/activemq/instances-available/baz/options" should be "absent"
  And file "/etc/activemq/instances-enabled/baz" should be "absent"

  And there should be a resource "Activemq::Instance[zaz]"
  And exec "activemq::instance::zaz(mkdir -p /mnt/activemq/zaz)" should be present
  And there should be a file "/etc/activemq/instances-available/zaz/activemq.xml"
  And there should be a file "/etc/activemq/instances-available/zaz/log4j.properties"
  And there should be a file "/etc/activemq/instances-available/zaz/options"
    And the file should contain "STARTTIME=5"
    And the file should contain /ACTIVEMQ_BASE="\/mnt\/activemq\/zaz"/
    And the file should contain /JAVA_HOME="\/opt\/java6\/"/
    And the file should contain /ACTIVEMQ_OPTS="-Xms1024M -Xmx2048M -Dorg.apache.activemq.UseDedicatedTaskRunner=true"/
    And the file should contain /ACTIVEMQ_ARGS="start xbean:foo.xml"/
  And file "/etc/activemq/instances-enabled/zaz" should be "link"

  And there should be a resource "Activemq::Instance[lol]"
  And there should be a file "/etc/activemq/instances-available/lol/activemq.xml"
    And the file should contain "foo"
  And there should be a file "/etc/activemq/instances-available/lol/log4j.properties"
    And the file should contain "foo"
  And there should be a file "/etc/activemq/instances-available/lol/options"
    And the file should contain "foo"
  And file "/etc/activemq/instances-enabled/lol" should be "link"

  And there should be a resource "Activemq::Instance[cat]"
  And there should be a file "/etc/activemq/instances-available/cat/activemq.xml"
    And the file should have a "source" of "puppet:///modules/foo/bar/activemq.xml"
  And there should be a file "/etc/activemq/instances-available/cat/log4j.properties"
    And the file should have a "source" of "puppet:///modules/foo/bar/log4j.properties"
  And there should be a file "/etc/activemq/instances-available/cat/options"
    And the file should have a "source" of "puppet:///modules/foo/bar/options"
  And file "/etc/activemq/instances-enabled/cat" should be "link"

  And there should be a resource "Activemq::Instance[haz]"
  And there should be a file "/etc/activemq/instances-available/haz/activemq.xml"
    And the file should contain "NO_START"
  And there should be a file "/etc/activemq/instances-available/haz/log4j.properties"
    And the file should contain "NO_START"
  And there should be a file "/etc/activemq/instances-available/haz/options"
    And the file should contain "NO_START"
  And file "/etc/activemq/instances-enabled/haz" should be "link"
