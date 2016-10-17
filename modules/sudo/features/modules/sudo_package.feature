Feature: sudo/package.pp
  In order to manage sudo on a system. The sudo::package class class should 
  ensure that sudo is either installed or not.

  Scenario: Sudo Package default
  Given a node named "class-sudo-package-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And package "sudo" should be "latest"

  Scenario: Sudo Package absent
  Given a node named "class-sudo-package-absent"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And package "sudo" should be "absent"

  Scenario: Sudo Package different package name
  Given a node named "class-sudo-diff-package-name"
  And a fact "location" of "development"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And package "sudo-2.3" should be "present"
