Feature: w3pw/config.pp
  In order to w3pwor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: w3pw::config default
    Given a node named "w3pw-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/usr/share/w3pw/lib/config.php" should be "present"
      And the file should contain /define\("DB_HOST", "localhost"\);/
      And the file should contain /define\("DB_NAME", "w3pw"\);/
      And the file should contain /define\("DB_USER", "root"\);/
      And the file should contain /define\("DB_PASS", ""\);/
      And the file should contain /define\("DB_PORT", 3306\);/

    Scenario: w3pw::config from facts
    Given a node named "w3pw-config-default"
    And a fact "w3pw_dbuser" of "w3pw"
    And a fact "w3pw_dbname" of "pvault"
    And a fact "w3pw_dbhost" of "test.local"
    And a fact "w3pw_dbpass" of "foo"
    And a fact "w3pw_dbport" of "4000"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/usr/share/w3pw/lib/config.php" should be "present"
      And the file should contain /define\("DB_HOST", "test.local"\);/
      And the file should contain /define\("DB_NAME", "pvault"\);/
      And the file should contain /define\("DB_USER", "w3pw"\);/
      And the file should contain /define\("DB_PASS", "foo"\);/
      And the file should contain /define\("DB_PORT", 4000\);/

    Scenario: w3pw::config no parameters
    Given a node named "w3pw-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
