Feature: python/package.pp
  In order to manage packages necessary for python scripts to run, this define
  will install a list of packages either using distro provider or the pip 
  provider.

    Scenario: python::package default
    Given a node named "define-python-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name              | state   |
      | python-dev        | latest  |
      | python-pip        | latest  |
      | python-dnspython  | latest  |
      | python-yaml       | latest  |
      | python-crypto     | latest  |

    Scenario: python::package custom packages
    Given a node named "define-python-package-custom-packages"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name  | state  |
      | foo   | latest |
      | bar   | latest |

    Scenario: python::package pip provider
    Given a node named "define-python-package-pip-provider"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name    | state |
      | cirrus | present |
