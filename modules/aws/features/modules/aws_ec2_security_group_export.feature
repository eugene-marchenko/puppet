Feature: aws/ec2/security/group/export.pp
  In order to maintain our Security Group ACLs. We should run a script
  periodically that will export security groups. This class should install the
  resources necessary to run that script.

    Scenario: aws::ec2::security::group::export default
    Given a node named "aws-ec2-security-group-export-default"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: aws::ec2::security::group::export with required params
    Given a node named "aws-ec2-security-group-export-required-params"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/export-security-groups.py"
      And the file should contain "ACCESSKEY='FOO'"
      And the file should contain "SECRETKEY='BAR'"

    Scenario: aws::ec2::security::group::export from source diff path
    Given a node named "aws-ec2-security-group-export-from-source-diff-path"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/bin/export.pl"
      And the file should have a "source" of "puppet:///modules/aws/ec2/security/group/export.pl"

    Scenario: aws::ec2::security::group::export from content
    Given a node named "aws-ec2-security-group-export-from-content"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/export-security-groups.py"
      And the file should contain "foo"

    Scenario: aws::ec2::security::group::export uninstalled
    Given a node named "aws-ec2-security-group-export-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/usr/local/bin/export-security-groups.py" should be "absent"
