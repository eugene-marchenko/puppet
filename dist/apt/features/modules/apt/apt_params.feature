Feature: params.pp
  In order to have effective package management
  The apt class should be able to use params to help manage packages
  And consolidate configuration options

  Scenario: Class apt::params
  Given a node named "class-params"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve

  And there should be a resource "Class[Apt::Params]"
    
  Scenario:
  Given a node named "class-params-duplicate"
  When I compile the catalog
  Then the compilation should fail

  Scenario:
  Given a node named "class-params-param"
  When I compile the catalog
  Then the compilation should fail
