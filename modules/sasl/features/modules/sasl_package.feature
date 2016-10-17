Feature: sasl/package.pp
  In order to saslor services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: sasl::package default
    Given a node named "sasl-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name              | state   |
      | sasl2-bin         | latest  |
      | libgsasl7         | latest  |
      | libsasl2-2        | latest  |
      | libsasl2-modules  | latest  |

    Scenario: sasl::package no parameters
    Given a node named "sasl-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
