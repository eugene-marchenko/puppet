Feature: sudo/config.pp
  In order to manage sudoers on a system. The sudoer config class should 
  take an arbitrary list of sudoers, and pass off to sudo::config::sudoers.pp
  for creating sudoer files.

  Scenario: Sudoers Config default
  Given a node named "class-sudo-config-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/sudoers.d/sysadmins" should be "present"

  Scenario: Sudoers Config custom users
  Given a node named "class-sudo-config-custom-users"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/sudoers.d/johnny" should be "present"
  And file "/etc/sudoers.d/bill" should be "present"

  Scenario: Sudoers Config params
  Given a node named "class-sudo-config-sudoer-from-params"
  And a fact "location" of "foo"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/sudoers.d/sysadmins" should be "present"

  Scenario: Sudoers Config with fact location
  Given a node named "class-sudo-config-sudoer-from-location-fact"
  And a fact "location" of "development"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/sudoers.d/sysadmins" should be "present"
  And file "/etc/sudoers.d/developers" should be "present"

  Scenario: Sudoers Config absent
  Given a node named "class-sudo-config-sudoers-absent"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/sudoers.d/sysadmins" should be "absent"
