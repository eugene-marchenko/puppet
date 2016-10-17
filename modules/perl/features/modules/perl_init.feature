Feature: perl/init.pp
  In order to manage perl modules on a system this class should install
  core packages from the distro's apt repository.

    Scenario: perl default
    Given a node named "class-perl"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name          | state   |
      | perl          | latest  |
      | perl-base     | latest  |
      | perl-modules  | latest  |
      | perl-doc      | latest  |

    Scenario: perl uninstalled
    Given a node named "class-perl-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name          | state   |
      | perl          | absent  |
      | perl-base     | absent  |
      | perl-modules  | absent  |
      | perl-doc      | absent  |

    Scenario: perl installed invalid
    Given a node named "class-perl-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: perl install custom packages
    Given a node named "class-perl-packages-custom"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name                    | state        |
      | perl                    | latest       |
      | libnet-amazon-ec2-perl  | latest       |
      | libio-string-perl       | uninstalled  |
      | libmailtools-perl       | present      |

    Scenario: perl install complex chaining example
    Given a node named "class-perl-complex-chaining-example"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name                    | state   |
      | perl                    | latest  |
      | perl-base               | latest  |
      | perl-modules            | latest  |
      | perl-doc                | latest  |
      | libxml-simple-perl      | 2.18-3  |
      | libnet-amazon-ec2-perl  | 0.14-1  |
