Feature: python/pip/package.pp
  In order to manage pip packages necessary for python scripts to run, class
  will create a set of virtual package resources for other classes to realize.

    Scenario: python::pip::package default
    Given a node named "class-python-pip-packages-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Package[BeautifulSoup]"
    And there should be no resource "Package[jinja2]"
    And there should be no resource "Package[lxml]"
    And there should be no resource "Package[mechanize]"
    And there should be no resource "Package[simplejson]"
    And there should be no resource "Package[pysolr]"
    And there should be no resource "Package[jenkinsapi]"
    And there should be no resource "Package[jprops]"

    Scenario: python::pip::package realized
    Given a node named "class-python-pip-packages-realized"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name          | state   |
      | BeautifulSoup | latest  |
      | jinja2        | latest  |
      | lxml          | latest  |
      | mechanize     | latest  |
      | simplejson    | latest  |
      | pysolr        | latest  |
      | jenkinsapi    | latest  |
      | jprops        | latest  |

    Scenario: python::package realized through collection
    Given a node named "class-python-pip-packages-collection"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name          | state |
      | BeautifulSoup | 1.0.1 |
      | jinja2        | 1.0.1 |
      | lxml          | 1.0.1 |
      | mechanize     | 1.0.1 |
      | simplejson    | 1.0.1 |
      | pysolr        | 1.0.1 |
      | jenkinsapi    | 1.0.1 |
      | jprops        | 1.0.1 |
