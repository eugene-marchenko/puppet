Feature: skeleton_pkg_only/packages.pp
  In order to manage skeleton_pkg_only on a system. This class must install the packages
  necessary for skeleton_pkg_only. 

    Scenario: skeleton_pkg_only::packages default
    Given a node named "class-skeleton_pkg_only-packages-default"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name              | state   |
      | skeleton_pkg_only | latest  |

    Scenario: skeleton_pkg_only::packages uninstalled
    Given a node named "class-skeleton_pkg_only-packages-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name              | state   |
      | skeleton_pkg_only | absent  |

    Scenario: skeleton_pkg_only::packages different version
    Given a node named "class-skeleton_pkg_only-packages-diff-version"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name              | state       |
      | skeleton_pkg_only | foo-version |

    Scenario: skeleton_pkg_only::packages uninstall overrides
    Given a node named "class-skeleton_pkg_only-packages-diff-uninstall-overrides"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name              | state   |
      | skeleton_pkg_only | absent  |
