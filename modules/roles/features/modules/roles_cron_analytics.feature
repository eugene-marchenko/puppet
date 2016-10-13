Feature: roles/cron/analytics.pp
  In order to run the nw-analytics app which refreshes recommended links on
  the website, this class should install the nw-analytics package, and any
  config files/cronjobs necessary to run the application.

    Scenario: roles::cron::analytics no facts
    Given a node named "class-roles-cron-analytics"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::cron::analytics from facts
    Given a node named "class-roles-cron-analytics"
    And a fact "nw_analytics_omniture_user" of "FOO"
    And a fact "nw_analytics_omniture_pass" of "FOO"
    And a fact "nw_analytics_aws_access_key" of "FOO"
    And a fact "nw_analytics_aws_secret_key" of "FOO"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[java]"
    And there should be a resource "Class[nw_analytics]"
    And there should be a resource "Class[roles::backports]"
    And there should be a resource "Cron::Crontab[nw-analytics]"
      And the resource should have a "command" of "/usr/bin/FetchWebLogsAndGenerateRecommendedLinksJavascriptFile.sh | logger -t nw-analytics"
