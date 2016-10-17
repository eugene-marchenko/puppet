Feature: route53/init.pp
  In order to manage the route53 service. The init class must install both
  route53 scripts and execs necessary to run the scripts to register the node
  with route53.

    Scenario: route53::init with ec2
    Given a node named "class-route53-init-ec2"
    And a fact "ec2_public_hostname" of "ec2-107-21-176-105.compute-1.amazonaws.com"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/etc/init.d/r53"
      And the file should contain "address=ec2-107-21-176-105.compute-1.amazonaws.com"
    And there should be a restricted script "/usr/local/bin/cli53.py"
    And there should be a resource "Exec[route53_run]"
      And the exec should have a "command" of "/etc/init.d/r53"
      And the exec should have an "unless" of "dig +short CNAME class-route53-init-ec2.local|grep -q ec2-107-21-176-105.compute-1.amazonaws.com"
    And there should be a resource "Exec[route53_service]"
      And the exec should have a "command" of "update-rc.d r53 defaults"

    Scenario: route53::init with ip
    Given a node named "class-route53-init-ip"
    And a fact "ipaddress" of "127.0.0.1"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/etc/init.d/r53"
      And the file should contain "address=127.0.0.1"
    And there should be a restricted script "/usr/local/bin/cli53.py"
    And there should be a resource "Exec[route53_run]"
      And the exec should have a "command" of "/etc/init.d/r53"
      And the exec should have an "unless" of "dig +short A class-route53-init-ip.local|grep -q 127.0.0.1"
    And there should be a resource "Exec[route53_service]"
      And the exec should have a "command" of "update-rc.d r53 defaults"

    Scenario: route53::init no route53 keys
    Given a node named "class-route53-init-no-route53-keys"
    And without fact "route53_aws_access_key"
    And without fact "route53_aws_secret_access_key"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: route53::init no run
    Given a node named "class-route53-init-no-run"
    And a fact "ec2_public_hostname" of "ec2-107-21-176-105.compute-1.amazonaws.com"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/etc/init.d/r53"
    And there should be a restricted script "/usr/local/bin/cli53.py"
    And there should be a resource "Exec[route53_service]"
      And the exec should have a "command" of "update-rc.d r53 defaults"
    And there should be no resource "Exec[route53_run]"

    Scenario: route53::init no enable
    Given a node named "class-route53-init-no-enable"
    And a fact "ec2_public_hostname" of "ec2-107-21-176-105.compute-1.amazonaws.com"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/etc/init.d/r53"
    And there should be a restricted script "/usr/local/bin/cli53.py"
    And there should be a resource "Exec[route53_service]"
      And the exec should have a "command" of "update-rc.d -f r53 remove"
    And there should be a resource "Exec[route53_run]"
