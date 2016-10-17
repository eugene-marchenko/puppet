Feature: perl/package.pp
  In order to manage packages necessary for perl scripts to run, this define
  will install those packages.

    Scenario: perl::package default
    Given a node named "define-perl-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name          | state   |
      | perl          | latest  |
      | perl-base     | latest  |
      | perl-modules  | latest  |
      | perl-doc      | latest  |

    Scenario: perl::package custom packages
    Given a node named "define-perl-package-custom-packages"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name  | state  |
      | foo   | latest |
      | bar   | latest |
