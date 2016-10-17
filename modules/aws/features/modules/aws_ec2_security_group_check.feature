Feature: aws/ec2/security/group/check.pp
  In order to keep our Security Group ACLs clean. We should run a script
  periodically that will check security groups. This class should install the
  resources necessary to run that script.

    Scenario: aws::ec2::security::group::check default
    Given a node named "aws-ec2-security-group-check-default"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: aws::ec2::security::group::check with required params
    Given a node named "aws-ec2-security-group-check-required-params"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/check-security-groups.py"
      And the file should contain "ACCESSKEY='FOO'"
      And the file should contain "SECRETKEY='BAR'"

    Scenario: aws::ec2::security::group::check from source diff path
    Given a node named "aws-ec2-security-group-check-from-source-diff-path"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/bin/check.pl"
      And the file should have a "source" of "puppet:///modules/aws/ec2/security/group/check.pl"

    Scenario: aws::ec2::security::group::check from content
    Given a node named "aws-ec2-security-group-check-from-content"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/check-security-groups.py"
      And the file should contain "foo"

    Scenario: aws::ec2::security::group::check uninstalled
    Given a node named "aws-ec2-security-group-check-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/usr/local/bin/check-security-groups.py" should be "absent"
