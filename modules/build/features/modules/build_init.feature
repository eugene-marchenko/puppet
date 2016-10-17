Feature: build/init.pp
  In order to manage build essential packages on a system this class should 
  install them.

    Scenario: build default
    Given a node named "class-build-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name            | state   |
      | build-essential | latest  |

    Scenario: build uninstalled
    Given a node named "class-build-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name            | state   |
      | build-essential | purged  |

    Scenario: build installed invalid
    Given a node named "class-build-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail
