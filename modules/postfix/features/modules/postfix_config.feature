Feature: postfix/config.pp
  In order to postfixor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: postfix::config default
    Given a node named "postfix-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/postfix/main.cf"
      And the file should contain "myhostname = postfix-config-default"
      And the file should contain "mydestination = $myhostname.$mydomain, $myhostname, localhost.$mydomain, localhost"
      And the file should contain "mydomain = local"
      And the file should contain "#broken_sasl_auth_clients = no"
    And there should be a file "/etc/postfix/master.cf"
    And there should be a file "/etc/mailname"
      And the file should contain "test.local"
    And following directories should be created:
      | name                        |
      | /var/spool/postfix/var      |
      | /var/spool/postfix/var/run  |

    Scenario: postfix::config from facts
    Given a node named "postfix-config-from-facts"
    And a fact "postfix_hostname" of "mxr.thedailybeast.com"
    And a fact "postfix_domain" of "thedailybeast.com"
    And a fact "postfix_mydestination" of "mxr.thedailybeast.com, mxr"
    And a fact "postfix_smtpd_recipient_restrictions" of "permit_sasl_authenticated, permit_mynetworks"
    And a fact "postfix_mynetworks" of "64.18.0.0/20"
    And a fact "postfix_smtpd_sasl_auth_enable" of "yes"
    And a fact "postfix_smtpd_sasl_security_options" of "noanonymous"
    And a fact "postfix_smtpd_sasl_local_domain" of "$mydomain"
    And a fact "postfix_smtpd_sasl_authenticated_header" of "yes"
    And a fact "postfix_broken_sasl_auth_clients" of "yes"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/postfix/main.cf"
      And the file should contain "myhostname = mxr.thedailybeast.com"
      And the file should contain "mydomain = thedailybeast.com"
      And the file should contain "mydestination = mxr.thedailybeast.com, mxr, localhost.$mydomain, localhost"
      And the file should contain "smtpd_recipient_restrictions = permit_sasl_authenticated, permit_mynetworks"
      And the file should contain "mynetworks = 64.18.0.0/20 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128"
      And the file should contain "smtpd_sasl_auth_enable = yes"
      And the file should contain "smtpd_sasl_security_options = noanonymous"
      And the file should contain "smtpd_sasl_local_domain = $mydomain"
      And the file should contain "smtpd_sasl_authenticated_header = yes"
      And the file should contain "broken_sasl_auth_clients = yes"
    And there should be a file "/etc/postfix/master.cf"
    And there should be a file "/etc/mailname"
      And the file should contain "test.local"
    And following directories should be created:
      | name                        |
      | /var/spool/postfix/var      |
      | /var/spool/postfix/var/run  |

    Scenario: postfix::config no parameters
    Given a node named "postfix-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
