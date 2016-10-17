Feature: python/package/base.pp
  In order to manage packages necessary for python scripts to run, this class
  will install a list of packages as virtual package resources and realize them
  so that other modules that declare those resources won't conflict.

    Scenario: python::package::base default
    Given a node named "class-python-package-base-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name             | state   |
      | python-dev       | latest  |
      | python-dnspython | latest  |
      | python-paramiko  | latest  |
      | python-yaml      | latest  |
      | python-crypto    | latest  |
      | boto             | present |
      | Cirrus           | present |

    Scenario: python::packages custom packages
    Given a node named "class-python-package-base-custom-packages"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name  | state  |
      | foo   | latest |
      | bar   | latest |
