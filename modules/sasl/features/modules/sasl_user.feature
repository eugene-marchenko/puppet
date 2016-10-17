Feature: user.pp
  In order to authenticate sasl clients, sasl users must be added to the sasldb.
  This define will add or remove those users from the sasldb.

    Scenario: Define sasl::user add default
    Given a node named "define-sasl-user-add-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Sasl::User[relay]"
      And the resource should have "ensure" set to "true"
      And the resource should have a "password" of "s3cur3"
      And the resource should have a "dbfile" of "/etc/sasldb2"
    And there should be a resource "Exec[sasl-manage-relay]"
      And the resource should have a "command" of "echo s3cur3 | saslpasswd2 -p -f /etc/sasldb2 relay"
      And the resource should have an "unless" of "sasldblistusers2 -f /etc/sasldb2 | grep -q relay"

    Scenario: Define sasl::user remove
    Given a node named "define-sasl-user-remove-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Sasl::User[relay]"
      And the resource should have "ensure" set to "false"
      And the resource should have a "password" of "s3cur3"
      And the resource should have a "dbfile" of "/etc/sasldb2"
    And there should be a resource "Exec[sasl-manage-relay]"
      And the resource should have a "command" of "saslpasswd2 -d -f /etc/sasldb2 relay"
      And the resource should have an "onlyif" of "sasldblistusers2 -f /etc/sasldb2 | grep -q relay"

    Scenario: Define sasl::user add custom domain and file 
    Given a node named "define-sasl-user-add-with-domain-and-file"
    And a fact "postfix_chroot" of "/var/spool/postfix"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Sasl::User[relay]"
      And the resource should have "ensure" set to "true"
      And the resource should have a "password" of "s3cur3"
      And the resource should have a "dbfile" of "/etc/sasldb2"
      And the resource should have an "mx_domain" of "relay.example.com"
    And there should be a resource "Exec[sasl-manage-relay]"
      And the resource should have a "command" of "echo s3cur3 | saslpasswd2 -p -f /var/spool/postfix/etc/sasldb2 -u relay.example.com relay"
      And the resource should have an "unless" of "sasldblistusers2 -f /var/spool/postfix/etc/sasldb2 | grep -q relay@relay.example.com"

    Scenario: Define sasl::user remove custom domain and file
    Given a node named "define-sasl-user-remove-with-domain-and-file"
    And a fact "postfix_chroot" of "/var/spool/postfix"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Sasl::User[relay]"
      And the resource should have "ensure" set to "false"
      And the resource should have a "password" of "s3cur3"
      And the resource should have a "dbfile" of "/etc/sasldb2"
    And there should be a resource "Exec[sasl-manage-relay]"
      And the resource should have a "command" of "saslpasswd2 -d -f /var/spool/postfix/etc/sasldb2 -u relay.example.com relay"
      And the resource should have an "onlyif" of "sasldblistusers2 -f /var/spool/postfix/etc/sasldb2 | grep -q relay@relay.example.com"


