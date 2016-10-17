Feature: ruby/gem/package.pp
  In order to manage gem packages necessary for ruby scripts to run, class
  will create a set of virtual package resources for other classes to realize.

    Scenario: ruby::gem::package default
    Given a node named "class-ruby-gem-packages-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Package[curb]"
    And there should be no resource "Package[nokogiri]"
    And there should be no resource "Package[highline]"

    Scenario: ruby::gem::package realized
    Given a node named "class-ruby-gem-packages-realized"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name      | state   |
      | curb      | latest  |
      | nokogiri  | latest  |
      | highline  | latest  |

    Scenario: ruby::package realized through collection
    Given a node named "class-ruby-gem-packages-collection"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name      | state |
      | curb      | 1.0.1 |
      | nokogiri  | 1.0.1 |
      | highline  | 1.0.1 |
