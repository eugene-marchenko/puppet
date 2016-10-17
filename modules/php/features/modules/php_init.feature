Feature: php/init.pp
  In order to manage php essential packages on a system this class should 
  install them.

    Scenario: php default
    Given a node named "class-php-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name  | state   |
      | php5  | latest  |

    Scenario: php uninstalled
    Given a node named "class-php-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    Then following packages should be dealt with:
      | name        | state   |
      | php5        | purged  |
      | php-pear    | purged  |
      | php5-cgi    | purged  |
      | php5-common | purged  |
      | php5-curl   | purged  |
      | php5-dbg    | purged  |
      | php5-dev    | purged  |
      | php5-gd     | purged  |
      | php5-gmp    | purged  |
      | php5-ldap   | purged  |
      | php5-mysql  | purged  |
      | php5-mcrypt | purged  |
      | php5-odbc   | purged  |
      | php5-pgsql  | purged  |
      | php5-pspell | purged  |
      | php5-recode | purged  |
      | php5-snmp   | purged  |
      | php5-sqlite | purged  |
      | php5-tidy   | purged  |
      | php5-xmlrpc | purged  |
      | php5-xsl    | purged  |

    Scenario: php installed invalid
    Given a node named "class-php-installed-invalid"
    When I try to compile the catalog
    Then compilation should fail
