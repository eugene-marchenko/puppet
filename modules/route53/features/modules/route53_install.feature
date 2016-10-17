Feature: route53/install.pp
  In order to manage the scripts necessary to run route53. This class must
  take a config file hash, grab the keys from it and pass those off to the
  route53::manage::file.pp define so it can install the files.

    Scenario: route53::install with ipaddress
    Given a node named "class-route53-install-ipaddress"
    And a fact "ipaddress" of "127.0.0.1"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/etc/init.d/r53"
      And the file should contain "AWS_ACCESS_KEY_ID=AAAAAAAAAAAAAAAAAAAAAAAA"
      And the file should contain "AWS_SECRET_ACCESS_KEY=BBBBBBBBBBBBBBBBBBBBBBBBBB"
      And the file should contain "zone=local"
      And the file should contain "hostname=class-route53-install-ipaddress"
      And the file should contain "type=A"
      And the file should contain "address=127.0.0.1"
      And the file should contain "ttl=60"
    And there should be a restricted script "/usr/local/bin/cli53.py"

    Scenario: route53::install with ec2_public_hostname
    Given a node named "class-route53-install-ec2"
    And a fact "ec2_public_hostname" of "ec2-184-73-105-153.compute-1.amazonaws.com"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/etc/init.d/r53"
      And the file should contain "AWS_ACCESS_KEY_ID=AAAAAAAAAAAAAAAAAAAAAAAA"
      And the file should contain "AWS_SECRET_ACCESS_KEY=BBBBBBBBBBBBBBBBBBBBBBBBBB"
      And the file should contain "zone=local"
      And the file should contain "hostname=class-route53-install-ec2"
      And the file should contain "type=CNAME"
      And the file should contain "address=ec2-184-73-105-153.compute-1.amazonaws.com"
      And the file should contain "ttl=60"
    And there should be a restricted script "/usr/local/bin/cli53.py"

