Feature: lvm2/init.pp
  In order to manage lvm2 essential packages on a system this class should 
  install them.

    Scenario: lvm2 default
    Given a node named "class-lvm2-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state   |
      | lvm2  | latest  |
    And exec "/sbin/vgchange -ay" should be present

    Scenario: lvm2 uninstalled
    Given a node named "class-lvm2-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state   |
      | lvm2  | purged  |

    Scenario: lvm2 installed invalid
    Given a node named "class-lvm2-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail
