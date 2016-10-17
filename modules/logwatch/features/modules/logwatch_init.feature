Feature: logwatch/init.pp
  In order to manage logwatch essential packages on a system this class should 
  install them.

    Scenario: logwatch default
    Given a node named "class-logwatch-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state   |
      | logwatch  | latest  |

    Scenario: logwatch uninstalled
    Given a node named "class-logwatch-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state   |
      | logwatch  | purged  |

    Scenario: logwatch installed invalid
    Given a node named "class-logwatch-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail
