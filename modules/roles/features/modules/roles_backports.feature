Feature: roles/backports.pp
  In order for a node to install backports, this role should include the
  necessary backports ppa for other roles to include so that duplicate resource
  dependencies don't happen.

    Scenario: roles::backports 
    Given a node named "class-roles-backports"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Apt::Source[nw-backports]"
