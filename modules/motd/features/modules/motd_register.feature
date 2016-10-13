Feature: motd/register.pp
  In order to manage motd on a system. The motd::register define should allow
  other classes to register themselves as motd fragments to be concatenated
  into one motd file. 

  Scenario: motd::register
  Given a node named "motd-register"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/_etc_motd.tail/fragments/10_motd_fragment_Apache" should be "present"
    And the file should contain "    -- Apache"
  And file "/_etc_motd.tail/fragments/11_motd_fragment_Nginx" should be "present"
    And the file should contain "    -- Nginx"
  And file "/_etc_motd.tail/fragments/10_motd_fragment_Devtools help" should be "present"
    And the file should contain "    -- Do the following to create a debian package"

