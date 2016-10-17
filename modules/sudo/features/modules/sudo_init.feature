Feature: sudo/init.pp
  In order to manage sudo and sudoers on a system. The init.pp class should
  ensure that sudo and sudoers are either installed or not. 

  Scenario: Sudo init default
  Given a node named "class-sudo-init-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And package "sudo" should be "latest"
  And file "/etc/sudoers.d/sysadmins" should be "present"

  Scenario: Sudo init location development
  Given a node named "class-sudo-init-location-development"
  And a fact "location" of "development"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And package "sudo-2.3" should be "latest"
  And file "/etc/sudoers.d/sysadmins" should be "present"
  And file "/etc/sudoers.d/developers" should be "present"

  Scenario: Sudo init custom users
  Given a node named "class-sudo-init-custom-users"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And package "sudo" should be "latest"
  And file "/etc/sudoers.d/jack" should be "present"
  And file "/etc/sudoers.d/jill" should be "present"

  Scenario: Sudo init sudoers absent
  Given a node named "class-sudo-init-sudoers-absent"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And package "sudo" should be "latest"
  And file "/etc/sudoers.d/sysadmins" should be "absent"

  Scenario: Sudo init package absent
  Given a node named "class-sudo-init-package-absent"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And package "sudo" should be "absent"
  And file "/etc/sudoers.d/sysadmins" should be "absent"
