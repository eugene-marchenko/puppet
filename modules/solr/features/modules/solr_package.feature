Feature: solr/package.pp
  In order to solror services on a system. This define must take a hash of
  packages to install and create them.

    Scenario: solr::package default
    Given a node named "solr-package-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name        | state   |
      | solr-jetty  | latest  |

    Scenario: solr::package from facts
    Given a node named "solr-package-default"
    And a fact "solr_servlet_engine" of "tomcat"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name        | state   |
      | solr-tomcat | latest  |

    Scenario: solr::package from facts invalid fact value
    Given a node named "solr-package-default"
    And a fact "solr_servlet_engine" of "tomcat6"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name        | state   |
      | solr-jetty  | latest  |

    Scenario: solr::package no parameters
    Given a node named "solr-package-no-params"
    When I try to compile the catalog
    Then compilation should fail
