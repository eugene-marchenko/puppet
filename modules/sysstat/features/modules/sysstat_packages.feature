Feature: sysstat/packages.pp
  In order to manage packages necessary for sysstat scripts to run, this class
  will install a list of packages as virtual package resources and realize them
  so that other modules that declare those resources won't conflict.

    Scenario: sysstat::packages default
    Given a node named "class-sysstat-packages-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name            | state   |
      | sysstat         | latest  |
    And exec "make-sysstat-/var/local/preseed" should be present
    And following files should be created:
      | name                                |
      | /var/local/preseed/sysstat.preseed  |
    

    Scenario: sysstat::packages custom packages
    Given a node named "class-sysstat-packages-custom-packages"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name  | state  |
      | foo   | latest |
      | bar   | latest |

    Scenario: sysstat::packages hash
    Given a node named "class-sysstat-packages-hash"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name          | state   |
      | sysstat       | latest  |

    Scenario: sysstat::packages string
    Given a node named "class-sysstat-packages-string"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name            | state   |
      | sysstat-custom  | latest  |
