Feature: ruby/init.pp
  In order to manage ruby modules on a system this class should install
  core packages from the distro's apt repository and gem packages that aren't
  present or not current enough on the distro.

    Scenario: ruby default
    Given a node named "class-ruby"
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

    Scenario: ruby uninstalled
    Given a node named "class-ruby-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Package[ruby]"
    And there should be no resource "Package[ruby1.8]"
    And there should be no resource "Package[ruby1.8-dev]"
    And there should be no resource "Package[libruby]"
    And there should be no resource "Package[libruby1.8]"
    And there should be no resource "Package[rubygems]"

    Scenario: ruby installed invalid
    Given a node named "class-ruby-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: ruby install custom packages
    Given a node named "class-ruby-custom-packages"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name      | state       |
      | aws-sdk   | latest      |
      | nokogiri  | uninstalled |

    Scenario: ruby install complex chaining example
    Given a node named "class-ruby-complex-chaining-example"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name        | state       |
      | ruby        | latest      |
      | ruby1.8     | latest      |
      | ruby1.8-dev | latest      |
      | libruby     | latest      |
      | libruby1.8  | latest      |
      | rubygems    | latest      |
      | aws-sdk     | present     |
      | nokogiri    | absent      |

