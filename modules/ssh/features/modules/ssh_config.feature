Feature: config.pp
  In order to allow for ssh configuration, the config define should
  set arbitrary options in the ssh config

    Scenario: ssh::config with one option
    Given a node named "define-config-one-option"
    And a fact "ipaddress_lo" of "127.0.0.1"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And the augeas config option "/etc/ssh/sshd_config-ListenAddress" should exist
      And the option should have a value of "set ListenAddress '127.0.0.1'"

    Scenario: ssh::config with multiple options
    Given a node named "define-config-multiple-options"
    And a fact "ipaddress_lo" of "127.0.0.1"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[ssh]"
      And the state should be "installed"

    And there should be a resource "Class[ssh::package]"
    And there should be a resource "Class[ssh::service]"
    And there should be no resource "Class[ssh::config::default]"
    And there should be no resource "File['/etc/ssh/sshd_config']"

    And the augeas config option "/etc/ssh/sshd_config-ListenAddress" should exist
      And the option should have a value of "set ListenAddress '127.0.0.1'"
    And the augeas config option "/etc/ssh/sshd_config-PermitRootLogin" should exist
      And the option should have a value of "set PermitRootLogin 'no'"

    Scenario: ssh::config with augeas option disabled
    Given a node named "define-config-augeas-option-disabled"
    And a fact "fqdn" of "testhost.localhoset"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[ssh]"
      And the state should be "installed"

    And there should be a resource "Class[ssh::package]"
    And there should be a resource "Class[ssh::service]"
    And there should be no resource "Class[ssh::config::default]"
    And there should be no resource "File['/etc/ssh/sshd_config']"

    And the augeas config option "/etc/ssh/sshd_config-Host[. = '*']/LoginGraceTime" should exist
      And the option should have a value of "rm Host[. = '*']/LoginGraceTime"

    Scenario: ssh::config for root user
    Given a node named "define-config-root-user"
    When I try to compile the catalog
    Then compilation should succeed

    And the augeas config option "/root/.ssh/config-Host" should exist
      And the option should have a value of "set Host '*'"
    And the augeas config option "/root/.ssh/config-Host[. = '*']/ForwardAgent" should exist
      And the option should have a value of "set Host[. = '*']/ForwardAgent 'yes'"
