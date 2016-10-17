Feature: skeleton/packages.pp
  In order to manage skeleton on a system. This class must install the packages
  necessary for skeleton. 

    Scenario: skeleton::packages default
    Given a node named "class-skeleton-packages-default"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name      | state   |
      | skeleton  | latest  |

    Scenario: skeleton::packages uninstalled
    Given a node named "class-skeleton-packages-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name      | state   |
      | skeleton  | absent  |
