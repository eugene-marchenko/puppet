Feature: perl/package/base.pp
  In order to manage packages necessary for perl scripts to run, this class
  will install a list of packages as virtual package resources and realize them
  so that other modules that declare those resources won't conflict.

    Scenario: perl::package::base default
    Given a node named "class-perl-package-base-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name          | state   |
      | perl          | latest  |
      | perl-base     | latest  |
      | perl-modules  | latest  |
      | perl-doc      | latest  |

    Scenario: perl::packages custom packages
    Given a node named "class-perl-package-base-custom-packages"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name  | state  |
      | foo   | latest |
      | bar   | latest |
