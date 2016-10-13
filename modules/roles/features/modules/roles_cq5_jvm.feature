Feature: roles/cq5/java.pp
  In order to setup a cq5 server, java must be installed. In order to manage
  the version of java, this role will be able to configure this from a fact.

    Scenario: roles::cq5::java
    Given a node named "class-roles-cq5-jvm"
    When I try to compile the catalog
    Then compilation should succeed
    And following packages should be dealt with:
    | name                    | state   |
    | openjdk-6-jre           | latest  |
    | openjdk-6-jdk           | latest  |
    | openjdk-6-jre-headless  | latest  |
    | openjdk-6-jre-lib       | latest  |

    Scenario: roles::cq5::publish with java version set through fact
    Given a node named "class-roles-cq5-jvm"
    And a fact "java_version" of "6b24-1.11.1-4ubuntu2"
    When I try to compile the catalog
    Then compilation should succeed
    And following packages should be dealt with:
    | name                    | state                 |
    | openjdk-6-jre           | 6b24-1.11.1-4ubuntu2  |
    | openjdk-6-jdk           | 6b24-1.11.1-4ubuntu2  |
    | openjdk-6-jre-headless  | 6b24-1.11.1-4ubuntu2  |
    | openjdk-6-jre-lib       | 6b24-1.11.1-4ubuntu2  |

#      And a fact "java_version" of "6b24-1.11.1-4ubuntu2"
#      When I try to compile the catalog
#      Then compilation should succeed
#      And following packages should be dealt with:
#        | name                    | state                 |
#        | openjdk-6-jre           | 6b24-1.11.1-4ubuntu2  |
#        | openjdk-6-jdk           | 6b24-1.11.1-4ubuntu2  |
#        | openjdk-6-jre-headless  | 6b24-1.11.1-4ubuntu2  |
#        | openjdk-6-jre-lib       | 6b24-1.11.1-4ubuntu2  |