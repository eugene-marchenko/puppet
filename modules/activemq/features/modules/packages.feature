Feature: activemq/packages.pp
  In order to manage activemq on a system. This class must install the packages
  necessary for activemq. 

    Scenario: activemq::packages default
    Given a node named "class-activemq-packages-default"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name      | state   |
      | activemq  | latest  |

    Scenario: activemq::packages uninstalled
    Given a node named "class-activemq-packages-uninstalled"
    When I try to compile the catalog
    And following packages should be dealt with:
      | name      | state   |
      | activemq  | absent  |
