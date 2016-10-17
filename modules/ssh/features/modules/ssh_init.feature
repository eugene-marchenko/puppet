Feature: init.pp
  In order to have a basic ssh service, the ssh class
  must ensure that the package is installed, ensure that certain files 
  are present or absent and ensure that the service is running or stopped.

    Scenario: Basic node without required param
    Given a node named "class-init-default"
    When I try to compile the catalog
    Then compilation should succeed

    Scenario: Basic node with param 'installed'
    Given a node named "class-init-installed"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    And there should be a resource "Class[ssh]"
      And the state should be "installed"
    And there should be a resource "Class[ssh::params]"
    And there should be a resource "Class[ssh::package]"
      And the class should run before "Class[Ssh::Config::Default]"
      And the class should have a "stage" of "setup"
    And there should be a resource "Package[openssh-server]"
      And package "openssh-server" should be "present"
    And there should be a resource "Package[openssh-client]"
      And package "openssh-client" should be "present"

    And there should be a resource "Class[ssh::config::default]"
      And the class should notify "Class[Ssh::Service]"
      And the class should have a "stage" of "setup_infra"

    And there should be a file "/etc/ssh/sshd_config"
    And there should be a file "/etc/ssh/ssh_config"

    And there should be a resource "Class[ssh::service]"
      And the class should have a "stage" of "deploy_infra"
    
    And there should be a resource "Service[ssh]"
      And the state should be "running"
      And the service should have "enable" set to "true"
      And the service should have "hasrestart" set to "true"
      And the service should have "hasstatus" set to "true"

    Scenario: Basic node with param 'uninstalled'
    Given a node named "class-init-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    And there should be a resource "Class[ssh]"
      And the state should be "uninstalled"

    And there should be a resource "Class[ssh::package]"
      And the state should be "absent"

    And there should be a resource "Package[openssh-server]"
      And package "openssh-server" should be "absent"
    And there should be a resource "Package[openssh-client]"
      And package "openssh-client" should be "absent"

    And there should be no resource "Class[ssh::config::default]"
    And there should be no resource "File[/etc/ssh/sshd_config]"
    And there should be no resource "File[/etc/ssh/ssh_config]"
    And there should be no resource "Class[ssh::service]"
    And there should be no resource "Service[ssh]"

    Scenario: Node with custom config
    Given a node named "class-init-custom-configs"
    And a fact "fqdn" of "testnode"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    And there should be a resource "File[/etc/ssh/sshd_config]"
      And the file should be a symlink to "/etc/ssh/sshd_config.dist"

    And there should be a file "/etc/ssh/ssh_config"
      And the file should have a "source" of "puppet:///modules/ssh/ssh_config"

    And there should be a file "/etc/default/ssh"
      And the file should contain "testnode"

    Scenario: Node with package version
    Given a node named "class-init-with-package-version"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    And there should be a resource "Package[openssh-server]"
      And the state should be "1:5.9p1-2ubuntu1"

    Scenario: Node with package set to 'purged'
    Given a node named "class-init-with-package-purged"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[ssh]"
      And the state should be "uninstalled"

    And there should be a resource "Package[openssh-server]"
      And the state should be "purged"

    Scenario: Node with packagensure set to 'purged' but class set to 'installed'
    Given a node named "class-init-with-invalid-packageensure"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: Node with ssh stopped
    Given a node named "class-init-service-stopped"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    
    And there should be a resource "Class[ssh]"
    And there should be a resource "Class[ssh::config::default]"
    And there should be a resource "Class[ssh::service]"
    And there should be a resource "Package[openssh-server]"
      And the state should be "present"
    And there should be a resource "File[/etc/ssh/sshd_config]"
    And there should be a resource "Service[ssh]"
      And the state should be "stopped"
      And the service should have "enable" set to "false"

    Scenario: Node with hasstatus true but with pattern specified
    Given a node named "class-init-pattern-hassstatus-true"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: Node with hasstatus true but with status specified
    Given a node named "class-init-status-hasstatus-true"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: Node with pattern specified
    Given a node named "class-init-service-pattern"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    And there should be a resource "Class[ssh]"
    And there should be a resource "Class[ssh::config::default]"
    And there should be a resource "Class[ssh::service]"
    And there should be a resource "Package[openssh-server]"
      And the state should be "present"
    And there should be a resource "File[/etc/ssh/sshd_config]"
    And there should be a resource "Service[ssh]"
      And the state should be "running"
      And the service should have "enable" set to "true"
      And the service should have a "pattern" of "foo"

    Scenario: Node with stage deploy
    Given a node named "class-init-stage-deploy"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve

    And there should be a resource "Class[ssh]"
      And the class should have a "stage" of "deploy"
    And there should be a resource "Class[ssh::package]"
      And the class should have a "stage" of "setup"
    And there should be a resource "Class[ssh::config::default]"
      And the class should have a "stage" of "setup_infra"
    And there should be a resource "Class[ssh::service]"
      And the class should have a "stage" of "deploy_infra"
