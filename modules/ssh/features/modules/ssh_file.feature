Feature: file.pp
  Blah blah blah

    Scenario: ssh::config::file with correct hash
    Given a node named "define-config-file"
    And a fact "fqdn" of "testnode"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/ssh/sshd_config"
    And there should be a file "/etc/ssh/ssh_config"
    And there should be a file "/etc/default/ssh"

    Scenario: ssh::config::file with a custom file
    Given a node named "define-config-file-custom"
    And a fact "fqdn" of "testnode"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/root/.ssh/config"
      And the file should contain "testnode"

