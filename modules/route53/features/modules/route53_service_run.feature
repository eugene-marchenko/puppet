Feature: route53/service/run.pp
  In order to manage the route53 service. The service::run class must either run
  the route53 service or not.

    Scenario: route53::service::run run true
    Given a node named "class-route53-service-run-true"
    And a fact "route53_aws_access_key" of "AAAAAAAAAAAAAAAAAAAAAAAAAA"
    And a fact "route53_aws_secret_access_key" of "BBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Exec[route53_run]"
      And the exec should have a "command" of "/etc/init.d/r53"

    Scenario: route53::service::run run false
    Given a node named "class-route53-service-run-false"
    And a fact "route53_aws_access_key" of "AAAAAAAAAAAAAAAAAAAAAAAAAA"
    And a fact "route53_aws_secret_access_key" of "BBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
    When I compile the catalog
    Then compilation should succeed
    And there should be no resource "Exec[route53_run]"

    Scenario: route53::service::run run invalid
    Given a node named "class-route53-service-run-invalid"
    And a fact "route53_aws_access_key" of "AAAAAAAAAAAAAAAAAAAAAAAAAA"
    And a fact "route53_aws_secret_access_key" of "BBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
    When I try to compile the catalog
    Then compilation should fail
