Feature: roles/grapher.pp
  In order to push logs into redis for graphing, this role must be called

    Scenario: roles::grapher 
    Given a node named "class-roles-grapher"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    Scenario: roles::grapher from facts
    Given a node named "class-roles-grapher"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
