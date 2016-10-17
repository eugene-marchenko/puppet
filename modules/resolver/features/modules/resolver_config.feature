Feature: resolver/config.pp
  In order to resolv services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: resolver::config default
    Given a node named "resolver-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/resolv.conf" should be "present"
      And the file should contain "domain local"
      And the file should contain "nameserver 18.72.0.3"

    Scenario: resolver::config from facts
    Given a node named "resolver-config-from-facts"
    And a fact "resolver_domainname" of "ec2.thedailybeast.com"
    And a fact "resolver_nameservers" of "172.16.0.23 18.72.0.3"
    And a fact "resolver_searchpath" of "ec2.thedailybeast.com compute-1.internal"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/resolv.conf" should be "present"
      And the file should contain "domain ec2.thedailybeast.com"
      And the file should contain "search ec2.thedailybeast.com compute-1.internal"
      And the file should contain "nameserver 172.16.0.23"
      And the file should contain "nameserver 18.72.0.3"

    Scenario: resolver::config no parameters
    Given a node named "resolver-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
