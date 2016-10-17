Feature: s3cmd/init.pp
  In order to manage s3cmd packages on a system this class should 
  install them.

    Scenario: s3cmd default
    Given a node named "class-s3cmd-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state   |
      | s3cmd  | latest  |

    Scenario: s3cmd uninstalled
    Given a node named "class-s3cmd-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state   |
      | s3cmd  | purged  |

    Scenario: s3cmd installed invalid
    Given a node named "class-s3cmd-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail
