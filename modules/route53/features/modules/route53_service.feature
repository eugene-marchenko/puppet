Feature: route53/service.pp
  In order to manage the route53 service. The enable class must either enable
  the route53 service or not.

    Scenario: route53::service enable true
    Given a node named "class-route53-service-true"
    And a fact "route53_aws_access_key" of "AAAAAAAAAAAAAAAAAAAAAAAAAA"
    And a fact "route53_aws_secret_access_key" of "BBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Exec[route53_service]"
      And the exec should have a "command" of "update-rc.d r53 defaults"

    Scenario: route53::service enable false
    Given a node named "class-route53-service-false"
    And a fact "route53_aws_access_key" of "AAAAAAAAAAAAAAAAAAAAAAAAAA"
    And a fact "route53_aws_secret_access_key" of "BBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Exec[route53_service]"
      And the exec should have a "command" of "update-rc.d -f r53 remove"

    Scenario: route53::service enable invalid
    Given a node named "class-route53-service-invalid-enable"
    And a fact "route53_aws_access_key" of "AAAAAAAAAAAAAAAAAAAAAAAAAA"
    And a fact "route53_aws_secret_access_key" of "BBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
    When I try to compile the catalog
    Then compilation should fail
