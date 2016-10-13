Feature: roles/misc/mounts.pp
  In order to setup a server with a block device or devices necessary for other
  resources to function and allow for multiple different classes to require
  it, this role must setup a mount resource as a virtual resource so that other
  classes can realize it.

    Scenario: roles::misc::mounts
    Given a node named "class-roles-misc-mounts"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Exec[misc::mounts(mkdir -p /opt)]"
    And there should be a resource "Mount[/opt]"
      And the resource should have an "ensure" of "mounted"
      And the resource should have a "device" of "/dev/mapper/ftp-volume"
      And the resource should have an "fstype" of "xfs"
      And the resource should have an "options" of "defaults"

    Scenario: roles::misc::mounts from facts
    Given a node named "class-roles-misc-mounts-from-facts"
    And a fact "misc_mount_path" of "/d0/data"
    And a fact "misc_mount_device" of "/dev/sdm"
    And a fact "misc_mount_fstype" of "ext3"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Exec[misc::mounts(mkdir -p /d0/data)]"
    And there should be a resource "Mount[/d0/data]"
      And the resource should have an "ensure" of "mounted"
      And the resource should have a "device" of "/dev/sdm"
      And the resource should have an "fstype" of "ext3"
      And the resource should have an "options" of "defaults"
