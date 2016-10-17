Feature: sysstat/init.pp
  In order to manage sysstat modules on a system this class should install
  core packages 

    Scenario: sysstat default
    Given a node named "class-sysstat"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state   |
      | sysstat | latest  |

    Scenario: sysstat uninstalled
    Given a node named "class-sysstat-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Package[sysstat]"

    Scenario: sysstat installed invalid
    Given a node named "class-sysstat-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: sysstat install custom packages
    Given a node named "class-sysstat-custom-packages"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name  | state   |
      | foo   | latest  |
      | bar   | latest  |

    Scenario: sysstat install custom hiera
    Given a node named "class-sysstat-custom-hiera-packages"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state   |
      | foo     | latest  |
      | bar     | latest  |

    Scenario: sysstat install hash, custom key
    Given a node named "class-sysstat-custom-key"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name            | state   |
      | sysstat-common  | latest  |
