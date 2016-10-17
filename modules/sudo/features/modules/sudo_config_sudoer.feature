Feature: sudo/config/sudoer.pp
  In order to manage sudoers on a system. The sudoer define should take one
  sudoer, locate their sudoer config file and create the File resource.

  Scenario: Sudoer default
  Given a node named "define-sudo-config-sudoer-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/sudoers.d/sysadmins" should be "present"

  Scenario: Sudoer not found
  Given a node named "define-sudo-config-sudoer-notfound"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve

  Scenario: Sudoer absent
  Given a node named "define-sudo-config-sudoer-absent"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/sudoers.d/sysadmins" should be "absent"

  Scenario: Sudoer from template
  Given a node named "define-sudo-config-sudoer-from-template"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/sudoers.d/johndoe" should be "present"
    And the file should contain "johndoe ALL=(ALL) ALL"

  Scenario: Sudoer from template all privs
  Given a node named "define-sudo-config-sudoer-all-privs"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/sudoers.d/johndoe" should be "present"
    And the file should contain "johndoe ALL=(ALL) NOPASSWD:ALL"

  Scenario: Sudoer config from content
  Given a node named "define-sudo-config-sudoers-from-content"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/sudoers.d/defaults-insults" should be "present"
    And the file should contain "Defaults insults"
