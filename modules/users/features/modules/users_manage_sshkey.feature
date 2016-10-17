Feature: users/manage/ssh_key.pp
  In order to manage user's ssh keys on a system, the users::manage::sshkey
  define must ensure that the ssh key is either present or absent.

  Scenario: SSH Key with complete config
  Given a node named "define-sshkey-complete-config"
  When I compile the catalog
  Then compilation should succeed
  And key "johndoe" should be "present"
    And the key should have a "type" of "ssh-dss"
    And the key should have a "key" of "AAAAB3NzaC1yc2EAAAABIwAAAQEAzJTjwUBZ"
    And the key should have a "user" of "johndoe"
    And the key should have no "options"
    And the key should have no "target"

  Scenario: SSH Key with incomplete config options 
  Given a node named "define-sshkey-incomplete-config"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And key "johndoe" should be "present"
    And the key should have a "key" of "AAAAB3NzaC1yc2EAAAABIwAAAQEAzJTjwUBZ"
    And the key should have no "type"

  Scenario: SSH Key with ensure overriden
  Given a node named "define-sshkey-ensure-overriden"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And key "johndoe" should be "absent"

  Scenario: SSH Key with invalid ensure
  Given a node named "define-sshkey-invalid-ensure"
  When I try to compile the catalog
  Then compilation should fail

  Scenario: SSH Key with invalid type
  Given a node named "define-sshkey-invalid-type"
  When I try to compile the catalog
  Then compilation should fail

  Scenario: SSH Key with no config
  Given a node named "define-sshkey-no-config"
  When I try to compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And key "janedoe" should be "present"
    And the key should have a "key" of "AAAAB3NzaC1yc2EAAAABIwAAAQEAzJTjwUBZ"
    And the key should have a "type" of "ssh-rsa"
    And the key should have a "user" of "janedoe"
