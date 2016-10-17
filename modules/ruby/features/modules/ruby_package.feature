Feature: ruby/package.pp
  In order to manage packages necessary for ruby scripts to run, this define
  will install a list of packages either using distro provider or the gem
  provider.

    Scenario: ruby::package default
    Given a node named "define-ruby-package-default"
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

    Scenario: ruby::package custom packages
    Given a node named "define-ruby-package-custom-packages"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name  | state  |
      | foo   | latest |
      | bar   | latest |

    Scenario: ruby::package gem provider
    Given a node named "define-ruby-package-gem-provider"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state |
      | aws-sdk | present |
