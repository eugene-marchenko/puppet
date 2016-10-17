Feature: build/devtools.pp
  In order to manage a build devtools on a system this class should install
  those packages 

    Scenario: build devtools default
    Given a node named "class-build-devtools-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name                  | state   |
      | autoconf              | latest  |
      | automake1.9           | latest  |
      | g++                   | latest  |
      | libmysqlclient-dev    | latest  |
      | libxslt1.1            | latest  |
      | m4                    | latest  |
      | quilt                 | latest  |
      | dput                  | latest  |
      | dh-make               | latest  |
    And there should be a file "/root/README.Debian"

    Scenario: build devtools uninstalled
    Given a node named "class-build-devtools-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name                  | state   |
      | autoconf              | purged  |
      | automake1.9           | purged  |
      | g++                   | purged  |
      | libmysqlclient-dev    | purged  |
      | libxslt1.1            | purged  |
      | m4                    | purged  |
      | quilt                 | purged  |
      | dput                  | purged  |
      | dh-make               | purged  |

    Scenario: build devtools and build installed
    Given a node named "class-build-and-devtools-installed"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
