Feature: ntp/packages.pp
  In order to manage ntp on a system. This class must install the packages
  necessary for ntp. 

    Scenario: ntp::packages default
    Given a node named "class-ntp-packages-default"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name      | state   |
      | ntp  | latest  |

    Scenario: ntp::packages uninstalled
    Given a node named "class-ntp-packages-uninstalled"
    When I try to compile the catalog
    And following packages should be dealt with:
      | name      | state   |
      | ntp  | absent  |
