Feature: roles/mailrelay.pp
  In order to setup a central mail relay server, this role must create the necessary
  resources to accept mail and perform MX routing.

    Scenario: roles::mailrelay
    Given a node named "class-roles-mailrelay"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::mailrelay with facts
    Given a node named "class-roles-mailrelay"
    And a fact "sasl_relay_user_pass" of "f00"
    And a fact "mpp_relay_user_pass" of "f00"
    And a fact "fqdn" of "mxr.thedailybeast.com"
    And a fact "postfix_chroot" of "/var/spool/postfix"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[sasl]"
    And file "/var/spool/postfix/etc/sasldb2" should be "present"
    And file "/var/spool/postfix/var/run/saslauthd" should be "directory"
    And exec "sasl-manage-smtp-relay" should be present
      And the exec should have a "command" of "echo f00 | saslpasswd2 -p -f /var/spool/postfix/etc/sasldb2 -u mxr.thedailybeast.com smtp-relay"
      And the exec should have an "unless" of "sasldblistusers2 -f /var/spool/postfix/etc/sasldb2 | grep -q smtp-relay@mxr.thedailybeast.com"
    And exec "sasl-manage-mpp-relay" should be present
      And the exec should have a "command" of "echo f00 | saslpasswd2 -p -f /var/spool/postfix/etc/sasldb2 -u mxr.thedailybeast.com mpp-relay"
      And the exec should have an "unless" of "sasldblistusers2 -f /var/spool/postfix/etc/sasldb2 | grep -q mpp-relay@mxr.thedailybeast.com"
