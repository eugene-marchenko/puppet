Feature: s3cmd/packages.pp
  In order to manage packages necessary for s3cmd scripts to run, this class
  will install the necessary packages.

    Scenario: s3cmd::package default
    Given a node named "s3cmd-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name   | state   |
      | s3cmd | latest  |

    Scenario: s3cmd::package no params
    Given a node named "s3cmd-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
