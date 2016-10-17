Feature: cq5/export.pp
  In order to export cq5 content. This class should install the
  cq5 export script from either direct content, a puppet source, or a template.
  It should setup proper execution and ownership parameters and place the file
  in a sane location.

    Scenario: cq5::export default
    Given a node named "cq5-export-default"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: cq5::export with required params
    Given a node named "cq5-export-required-params"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/cq5-export-package.py"
      And the file should contain "ACCESSKEY='FOO'"
      And the file should contain "SECRETKEY='BAR'"

    Scenario: cq5::export from source diff path
    Given a node named "cq5-export-from-source-diff-path"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/bin/export.pl"
      And the file should have a "source" of "puppet:///modules/cq5/scripts/export.pl"

    Scenario: cq5::export from content
    Given a node named "cq5-export-from-content"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/cq5-export-package.py"
      And the file should contain "foo"

    Scenario: cq5::export uninstalled
    Given a node named "cq5-export-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/usr/local/bin/cq5-export-package.py" should be "absent"
