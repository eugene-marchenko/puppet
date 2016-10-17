Feature: java/init.pp
  In order to manage java essential packages on a system this class should 
  install them.

    Scenario: java default
    Given a node named "class-java-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name                    | state   |
      | java-common             | latest  |
      | openjdk-6-jre           | latest  |
      | openjdk-6-jdk           | latest  |
      | openjdk-6-jre-headless  | latest  |
      | openjdk-6-jre-lib       | latest  |
      | default-jre             | latest  |

    Scenario: java uninstalled
    Given a node named "class-java-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name                    | state   |
      | java-common             | absent  |
      | openjdk-6-jre           | absent  |
      | openjdk-6-jdk           | absent  |
      | openjdk-6-jre-headless  | absent  |
      | openjdk-6-jre-lib       | absent  |
      | default-jre             | absent  |
