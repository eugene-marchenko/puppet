Feature: build/devlibs.pp
  In order to manage common development libraries, this class should create
  Virtual Resources of common package dev libs for other classes to be able
  to Realize.

    Scenario: build devlibs default
    Given a node named "class-build-devlibs-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name                | state   |
      | libxml2-dev         | latest  |
      | libxslt1-dev        | 1.1.1   |
