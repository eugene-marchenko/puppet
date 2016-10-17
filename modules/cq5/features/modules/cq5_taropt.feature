Feature: cq5/taropt.pp
  In order prune cq5 disk usage, the taropt class should install the
  resources necessary to run a script to run the tarpm optimization. This
  class should install the cq5 taropt script from either direct content,
  a puppet source, or a template. It should setup proper execution and ownership
  parameters and place the file in a sane location.

    Scenario: cq5::taropt default
    Given a node named "cq5-taropt-default"
    When I try to compile the catalog
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/cq5-tar-optimization.rb"

    Scenario: cq5::taropt from source diff path
    Given a node named "cq5-taropt-from-source-diff-path"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/bin/taropt.pl"
      And the file should have a "source" of "puppet:///modules/cq5/scripts/taropt.pl"

    Scenario: cq5::taropt from content
    Given a node named "cq5-taropt-from-content"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a restricted script "/usr/local/bin/cq5-tar-optimization.rb"
      And the file should contain "foo"

    Scenario: cq5::taropt uninstalled
    Given a node named "cq5-taropt-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/usr/local/bin/cq5-tar-optimization.rb" should be "absent"
