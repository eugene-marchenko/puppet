Feature: mlocate/packages.pp
  In order to manage mlocate on a system. This class must install the packages
  necessary for mlocate. 

    Scenario: mlocate::packages default
    Given a node named "class-mlocate-packages-default"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name      | state   |
      | mlocate  | latest  |

    Scenario: mlocate::packages uninstalled
    Given a node named "class-mlocate-packages-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name      | state   |
      | mlocate  | absent  |
