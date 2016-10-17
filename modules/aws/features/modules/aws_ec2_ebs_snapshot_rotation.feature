Feature: aws/ec2/ebs/snapshot/rotation.pp
  In order to rotate snapshots. This class should install the snapshot rotation
  script from either direct content, a puppet source, or a template.
  It should setup proper execution and ownership parameters and place the file
  in a sane location.

    Scenario: aws::ec2::ebs::snapshot::rotation default
    Given a node named "aws-ec2-ebs-snapshot-rotation-default"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: aws::ec2::ebs::snapshot::rotation with required params
    Given a node named "aws-ec2-ebs-snapshot-rotation-required-params"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/snapshot-rotation.py"
      And the file should contain "ACCESSKEY='FOO'"
      And the file should contain "SECRETKEY='BAR'"

    Scenario: aws::ec2::ebs::snapshot::rotation from source diff path
    Given a node named "aws-ec2-ebs-snapshot-rotation-from-source-diff-path"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/bin/rotate.pl"
      And the file should have a "source" of "puppet:///modules/aws/ec2/ebs/snapshot/rotate.pl"

    Scenario: aws::ec2::ebs::snapshot::rotation from content
    Given a node named "aws-ec2-ebs-snapshot-rotation-from-content"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/snapshot-rotation.py"
      And the file should contain "foo"

    Scenario: aws::ec2::ebs::snapshot::rotation uninstalled
    Given a node named "aws-ec2-ebs-snapshot-rotation-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/usr/local/bin/snapshot-rotation.py" should be "absent"
