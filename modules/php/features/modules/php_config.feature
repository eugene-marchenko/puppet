Feature: php/config.pp
  In order to manage php services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: php::config default
    Given a node named "php-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/php5/cli/conf.d/foo.ini" should be "present"
      And the file should contain /foo = 10\n/

    Scenario: php::config no parameters
    Given a node named "php-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
