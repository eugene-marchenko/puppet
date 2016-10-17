Feature: python/init.pp
  In order to manage python modules on a system this class should install
  core packages from the distro's apt repository and pip packages that aren't
  present or not current enough on the distro.

    Scenario: python default
    Given a node named "class-python"
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

    Scenario: python uninstalled
    Given a node named "class-python-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name             | state   |
      | python-dev       | absent  |
      | python-dnspython | absent  |
      | python-paramiko  | absent  |
      | python-yaml      | absent  |
      | python-crypto    | absent  |
      | boto             | absent  |
      | Cirrus           | absent  |

    Scenario: python installed invalid
    Given a node named "class-python-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: python install custom packages
    Given a node named "class-python-packages-custom"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name             | state        |
      | python           | latest       |
      | mechanize        | latest       |
      | cheetah          | uninstalled  |
      | jinja2           | present      |

    Scenario: python install complex chaining example
    Given a node named "class-python-complex-chaining-example"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name              | state   |
      | python-dev        | latest  |
      | python-dnspython  | latest  |
      | python-paramiko   | latest  |
      | python-yaml       | latest  |
      | python-crypto     | latest  |
      | boto              | present |
      | Cirrus            | present |
      | jinja2            | 0.2.0   |
      | mechanize         | 1.0.0   |
