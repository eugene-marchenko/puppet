Feature: nw_analytics/config.pp
  In order to nw_analyticsor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: nw_analytics::config default
    Given a node named "nw_analytics-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/nw-analytics/nwdb-analytics.properties" should be "present"
      And the file should contain "omniture.ftp.hostname = ftp2.omniture.com"
      And the file should contain "omniture.ftp.username = test1"
      And the file should contain "omniture.ftp.password = test1"
      And the file should contain "amazon.aws.accessKey = AAAAAAAAAAAAAAAAAAAAAAAAAAA"
      And the file should contain "amazon.aws.secretKey = SSSSSSSSSSGGGGGGGGG333333333GGGGGGGGG"

    Scenario: nw_analytics::config from facts
    Given a node named "nw_analytics-config-default"
    And a fact "nw_analytics_omniture_host" of "test.local"
    And a fact "nw_analytics_omniture_user" of "foo"
    And a fact "nw_analytics_omniture_pass" of "foo"
    And a fact "nw_analytics_aws_access_key" of "FOO"
    And a fact "nw_analytics_aws_secret_key" of "BAR"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/nw-analytics/nwdb-analytics.properties" should be "present"
      And the file should contain "omniture.ftp.hostname = test.local"
      And the file should contain "omniture.ftp.username = foo"
      And the file should contain "omniture.ftp.password = foo"
      And the file should contain "amazon.aws.accessKey = FOO"
      And the file should contain "amazon.aws.secretKey = BAR"

    Scenario: nw_analytics::config no parameters
    Given a node named "nw_analytics-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
