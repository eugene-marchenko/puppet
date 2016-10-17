Feature: jmeter/init.pp
  In order to manage jmeter essential packages on a system this class should 
  install them.

    Scenario: jmeter default
    Given a node named "class-jmeter-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state   |
      | jmeter  | latest  |

    Scenario: jmeter uninstalled
    Given a node named "class-jmeter-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state   |
      | jmeter  | purged  |

    Scenario: jmeter installed invalid
    Given a node named "class-jmeter-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail
