Feature: sasl/config.pp
  In order to saslor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: sasl::config default
    Given a node named "sasl-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/default/saslauthd"
      And the file should contain /OPTIONS=\"-c -m /var/run/saslauthd\"/
    And file "/etc/sasldb2" should be "present"
    And there should be a resource "File[/var/run/saslauthd]"
      And the resource should have an "ensure" of "directory"
      And the resource should have a "group" of "sasl"

    Scenario: sasl::config from facts
    Given a node named "sasl-config-from-facts"
    And a fact "saslauthd_options" of "-c -m /opt/postfix/var/run/saslauthd"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/default/saslauthd"
      And the file should contain /OPTIONS=\"-c -m /opt/postfix/var/run/saslauthd\"/
    And file "/etc/sasldb2" should be "present"
    And there should be a resource "File[/var/run/saslauthd]"
      And the resource should have an "ensure" of "directory"
      And the resource should have a "group" of "sasl"

    Scenario: sasl::config postfix chroot
    Given a node named "sasl-config-postfix-chroot"
    And a fact "postfix_chroot" of "/var/spool/postfix"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/default/saslauthd"
      And the file should contain /OPTIONS=\"-c -m /var/spool/postfix/var/run/saslauthd\"/
    And file "/var/spool/postfix/etc/sasldb2" should be "present"
    And there should be a resource "File[/var/spool/postfix/var/run/saslauthd]"
      And the resource should have an "ensure" of "directory"
      And the resource should have a "group" of "sasl"

    Scenario: sasl::config no parameters
    Given a node named "sasl-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
