Feature: cq5/node.pp
  In order to manage cq5 on a system. The cq5 node define should install custom
  configs for a given cq5 node, including a correct serverctl script, and init
  script and start the service. It should take the necessary parameters and
  create sane defaults for optional parameters in creating those file resources.

    Scenario: cq5 author single node
    Given a node named "cq5-node-simple"
    When I compile the catalog
    Then compilation should succeed
    And there should be a script "/etc/init.d/cq5-author"
      And the file should contain /DESC="CQ5 Cluster author"/
      And the file should contain "ROOTDIR=/opt/cq5/author"
      And the file should contain "SERVERCTL=$ROOTDIR/crx-quickstart/server/serverctl"
      And the file should contain /OPTIONS="--port 8080 --permgen 256 --heap-max 768 --max-files 65535 --verbose-gc"/
      And the file should contain /JAVAOPTS="-XX:\+UseConcMarkSweepGC -XX:\+PrintGCDetails -XX:\+PrintGCTimeStamps  -Dsling.run.modes=author,prod"/
      And the file should contain /VOLUME=\n/
    And service "cq5-author" should be "running"
      And the service should have "enable" set to "true"

    Scenario: cq5 author diff jvm opts
    Given a node named "cq5-node-diff-jvm-params"
    When I compile the catalog
    Then compilation should succeed
    And there should be a script "/etc/init.d/cq5-author"
      And the file should contain /DESC="CQ5 Cluster author"/
      And the file should contain "ROOTDIR=/opt/cq5/author-node1"
      And the file should contain "SERVERCTL=$ROOTDIR/crx-quickstart/server/serverctl"
      And the file should contain /OPTIONS="--port 4502 --permgen 512 --heap-max 1024 --max-files 1024 --verbose-gc"/
      And the file should contain "VOLUME=/opt/cq5/author-node1"
    And service "cq5-author" should be "stopped"
      And the service should have "enable" set to "false"

    Scenario: cq5 server no gc opts
    Given a node named "cq5-node-no-gc-opts"
    When I compile the catalog
    Then compilation should succeed
    And there should be a script "/etc/init.d/cq5-node1"
      And the file should contain /DESC="CQ5 Cluster node1"/
      And the file should contain "ROOTDIR=/opt/cq5/node1"
      And the file should contain "SERVERCTL=$ROOTDIR/crx-quickstart/server/serverctl"
      And the file should contain /OPTIONS="--port 4502 --permgen 256 --heap-max 768 --max-files 65535"/
      And the file should contain "VOLUME=/opt/cq5/node1"
    And service "cq5-node1" should be "running"

    Scenario: cq5 server local interace diff java home
    Given a node named "cq5-node-diff-interface-java-home"
    When I compile the catalog
    Then compilation should succeed
    And there should be a script "/etc/init.d/cq5-author-internal"
      And the file should contain /DESC="CQ5 Cluster author-internal"/
      And the file should contain "ROOTDIR=/opt/cq5/author"
      And the file should contain "SERVERCTL=$ROOTDIR/crx-quickstart/server/serverctl"
      And the file should contain /OPTIONS="--port 4502 --permgen 256 --heap-max 768 --max-files 65535 --verbose-gc --interface 127.0.0.1 --javahome \/opt\/java6"/
      And the file should contain "VOLUME=/opt/cq5/author"
    And service "cq5-author-internal" should be "running"

    Scenario: cq5 node uninstalled
    Given a node named "cq5-node-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And file "/etc/init.d/cq5-publish" should be "absent"
    And there should be no resource "Service[cq5-publish]"

    Scenario: cq5 invalid role
    Given a node named "cq5-invalid-role"
    When I try to compile the catalog
    Then compilation should fail
