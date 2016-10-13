Feature: motd/init.pp
  In order to manage motd on a system. The motd class should allow creation
  and modification of /etc/motd.tail so that custom messages can be presented
  to the user upon signin.

  Scenario: motd default
  Given a node named "class-motd"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/_etc_motd.tail/fragments/01_motd_header" should be "present"
    And the file should contain "Puppet modules on this server"
  And file "/_etc_motd.tail/fragments/50_motd_end" should be "present"
    And the file should contain "-----------------------------"
