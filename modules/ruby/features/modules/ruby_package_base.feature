Feature: ruby/package/base.pp
  In order to manage packages necessary for ruby scripts to run, this class 
  will ensure that a base list of packages will be installed.

    Scenario: ruby::package::base default
    Given a node named "class-ruby-package-base-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name        | state   |
      | ruby        | latest  |
      | ruby1.8     | latest  |
      | ruby1.8-dev | latest  |
      | libruby     | latest  |
      | libruby1.8  | latest  |
      | rubygems    | latest  |

    Scenario: ruby::package::base custom packages
    Given a node named "class-ruby-package-base-custom-packages"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name  | state  |
      | foo   | latest |
      | bar   | latest |
