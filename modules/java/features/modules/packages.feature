Feature: java/packages.pp
  In order to manage java on a system. This class must install the packages
  necessary for java. 

    Scenario: java::packages default
    Given a node named "class-java-packages-default"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name                    | state   |
      | java-common             | latest  |
      | openjdk-6-jre           | latest  |
      | openjdk-6-jdk           | latest  |
      | openjdk-6-jre-headless  | latest  |
      | openjdk-6-jre-lib       | latest  |
      | default-jre             | latest  |

    Scenario: java::packages uninstalled
    Given a node named "class-java-packages-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name                    | state   |
      | java-common             | absent  |
      | openjdk-6-jre           | absent  |
      | openjdk-6-jdk           | absent  |
      | openjdk-6-jre-headless  | absent  |
      | openjdk-6-jre-lib       | absent  |
      | default-jre             | absent  |

    Scenario: java::packages different version
    Given a node named "class-java-packages-diff-version"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name                    | state       |
      | java-common             | foo-version |
      | openjdk-6-jre           | foo-version |
      | openjdk-6-jdk           | foo-version |
      | openjdk-6-jre-headless  | foo-version |
      | openjdk-6-jre-lib       | foo-version |
      | default-jre             | foo-version |

    Scenario: java::packages uninstall overrides
    Given a node named "class-java-packages-diff-uninstall-overrides"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name                    | state   |
      | java-common             | absent  |
      | openjdk-6-jre           | absent  |
      | openjdk-6-jdk           | absent  |
      | openjdk-6-jre-headless  | absent  |
      | openjdk-6-jre-lib       | absent  |
      | default-jre             | absent  |
