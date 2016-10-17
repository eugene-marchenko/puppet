Feature: php/packages.pp
  In order to manage common php libraries, this class should create
  Virtual Resources of common package php libs for other classes to be able
  to Realize.

    Scenario: php packages default
    Given a node named "class-php-packages-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And following packages should be dealt with:
      | name         | state   |
      | php5-mysql   | latest  |
      | php5-mcrypt  | 1.1.1   |
