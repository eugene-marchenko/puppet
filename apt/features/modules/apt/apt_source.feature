Feature: apt source.pp
  In order to have effective package management
  The apt class needs to have testing coverage
  And this covers source.pp
  
  Scenario: Basic apt::source instance with defaults
    Given a node named "source"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

  Scenario: Basic apt::source instance with defaults
    Given a node named "source"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "File[cucumber.list]"
      And the file should have an "owner" of "root"
      And the file should have a "group" of "root"
      And the file should have a "mode" of "644"
		And exec "cucumber apt update" should be present
			And the exec should have a "command" of "/usr/bin/apt-get update"
			And the exec should have a "subscribe" of "File[cucumber.list]"
			And the exec should have "refreshonly" set to "true"

			
  Scenario: Basic apt::source instance with defaults and a pin
    Given a node named "source-pin"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "File[cucumber.list]"
      And the file should have an "owner" of "root"
      And the file should have a "group" of "root"
      And the file should have a "mode" of "644"
		And exec "cucumber apt update" should be present
			And the exec should have a "command" of "/usr/bin/apt-get update"
			And the exec should have a "subscribe" of "File[cucumber.list]"
			And the exec should have "refreshonly" set to "true"
		And there should be a resource "Apt::Pin[cucumber]"

  Scenario: Basic apt::source instance with defaults and a key
    Given a node named "source-key"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "File[cucumber.list]"
      And the file should have an "owner" of "root"
      And the file should have a "group" of "root"
      And the file should have a "mode" of "644"
		And exec "cucumber apt update" should be present
			And the exec should have a "command" of "/usr/bin/apt-get update"
			And the exec should have a "subscribe" of "File[cucumber.list]"
			And the exec should have "refreshonly" set to "true"
		And exec "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABAD1DEA" should be present
			And the exec should have an "unless" of "/usr/bin/apt-key list | /bin/grep ABAD1DEA"
			And the exec should have a "before" of "File[cucumber.list]"

  Scenario: Basic apt::source instance with defaults and a key and a key content
    Given a node named "source-key-and-content"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "File[cucumber.list]"
      And the file should have an "owner" of "root"
      And the file should have a "group" of "root"
      And the file should have a "mode" of "644"
		And exec "cucumber apt update" should be present
			And the exec should have a "command" of "/usr/bin/apt-get update"
			And the exec should have a "subscribe" of "File[cucumber.list]"
			And the exec should have "refreshonly" set to "true"
		And exec "Add key: ABAD1DEA from content" should be present
			And the exec should have a "command" of "/bin/echo 'HEXHEXHEX' | /usr/bin/apt-key add -"
			And the exec should have an "unless" of "/usr/bin/apt-key list | /bin/grep 'ABAD1DEA'"
			And the exec should have a "before" of "File[cucumber.list]"

