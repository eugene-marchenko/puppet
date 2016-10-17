Feature: shells/config.pp
  In order to shellsor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: shells::config default
    Given a node named "shells-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/shells" should be "present"
      And the file should contain "/bin/sh"
      And the file should contain "/bin/dash"
      And the file should contain "/bin/bash"
      And the file should contain "/usr/bin/tmux"
      And the file should contain "/usr/bin/screen"
      And the file should contain "/bin/csh"
      And the file should contain "/bin/tcsh"
      And the file should contain "/bin/ksh"
      And the file should contain "/bin/false"


    Scenario: shells::config from facts
    Given a node named "shells-config-from-facts"
    And a fact "shells_allowed" of "/bin/foo"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/shells" should be "present"
      And the file should contain "/bin/foo"

    Scenario: shells::config no parameters
    Given a node named "shells-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
