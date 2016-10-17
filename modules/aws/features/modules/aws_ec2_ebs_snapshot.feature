Feature: aws/ec2/ebs/snapshot.pp
  In order to snapshot ebs volumes on a system. This class should install the
  ebs snapshot script from either direct content, a puppet source, or a template.
  It should setup proper execution and ownership parameters and place the file
  in a sane location.

    Scenario: aws::ec2::ebs::snapshot default
    Given a node named "aws-ec2-ebs-snapshot-default"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: aws::ec2::ebs::snapshot with required params
    Given a node named "aws-ec2-ebs-snapshot-required-params"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/ebs-snapshot.py"
      And the file should contain "ACCESSKEY='FOO'"
      And the file should contain "SECRETKEY='BAR'"

    Scenario: aws::ec2::ebs::snapshot from source diff path
    Given a node named "aws-ec2-ebs-snapshot-from-source-diff-path"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/bin/snapshot.pl"
      And the file should have a "source" of "puppet:///modules/aws/ec2/ebs/snapshot.pl"

    Scenario: aws::ec2::ebs::snapshot from content
    Given a node named "aws-ec2-ebs-snapshot-from-content"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/ebs-snapshot.py"
      And the file should contain "foo"

    Scenario: aws::ec2::ebs::snapshot uninstalled
    Given a node named "aws-ec2-ebs-snapshot-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/usr/local/bin/ebs-snapshot.py" should be "absent"
