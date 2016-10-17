Feature: mysql/init.pp
  In order to manage mysql essential packages on a system this class should 
  install them.

    Scenario: mysql default
    Given a node named "class-mysql-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name          | state   |
      | mysql-client  | latest  |

    Scenario: mysql uninstalled
    Given a node named "class-mysql-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name          | state   |
      | mysql-client  | purged  |

    Scenario: mysql installed invalid
    Given a node named "class-mysql-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail
