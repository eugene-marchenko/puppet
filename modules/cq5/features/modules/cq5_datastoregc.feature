Feature: cq5/datastoregc.pp
  In order prune cq5 disk usage, the datastoregc class should install the
  resources necessary to run a script to garbage collect datastore content. This
  class should install the cq5 datastoregc script from either direct content,
  a puppet source, or a template. It should setup proper execution and ownership
  parameters and place the file in a sane location.

    Scenario: cq5::datastoregc default
    Given a node named "cq5-datastoregc-default"
    When I try to compile the catalog
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/cq5-datastore-gc.rb"

    Scenario: cq5::datastoregc from source diff path
    Given a node named "cq5-datastoregc-from-source-diff-path"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/bin/datastoregc.pl"
      And the file should have a "source" of "puppet:///modules/cq5/scripts/datastoregc.pl"

    Scenario: cq5::datastoregc from content
    Given a node named "cq5-datastoregc-from-content"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/cq5-datastore-gc.rb"
      And the file should contain "foo"

    Scenario: cq5::datastoregc uninstalled
    Given a node named "cq5-datastoregc-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/usr/local/bin/cq5-datastore-gc.rb" should be "absent"
