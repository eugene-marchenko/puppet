Feature: skeleton_pkg_only/init.pp
  In order to manage skeleton_pkg_only essential packages on a system this class should 
  install them.

    Scenario: skeleton_pkg_only default
    Given a node named "class-skeleton_pkg_only-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name              | state   |
      | skeleton_pkg_only | latest  |

    Scenario: skeleton_pkg_only uninstalled
    Given a node named "class-skeleton_pkg_only-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name              | state   |
      | skeleton_pkg_only | absent |
