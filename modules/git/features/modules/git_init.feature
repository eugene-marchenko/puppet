Feature: git/init.pp
  In order to manage git essential packages on a system this class should 
  install them.

    Scenario: git default
    Given a node named "class-git-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name      | state   |
      | git       | latest  |
      | git-core  | latest  |

    Scenario: git uninstalled
    Given a node named "class-git-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name      | state   |
      | git       | purged  |
      | git-core  | purged  |

    Scenario: git installed invalid
    Given a node named "class-git-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail
