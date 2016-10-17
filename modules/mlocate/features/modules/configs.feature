Feature: mlocate/configs.pp
  In order to manage mlocate services on a system. This class must install the
  configs necessary for mlocate to run.

    Scenario: mlocate::config default
    Given a node named "class-mlocate-configs-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/updatedb.conf"
      And the file should contain /^PRUNEFS="NFS nfs nfs4 rpc_pipefs afs binfmt_misc proc smbfs autofs iso9660 ncpfs coda devpts ftpfs devfs mfs shfs sysfs cifs lustre_lite tmpfs usbfs udf fuse.glusterfs fuse.sshfs curlftpfs ecryptfs fusesmb devtmpfs"/
      And the file should contain /^PRUNEPATHS="/tmp /var/spool /media /home/.encrypfs /mnt"/

    Scenario: mlocate::config custom
    Given a node named "class-mlocate-configs-custom"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/updatedb.conf"
      And the file should contain /^PRUNE_BIND_MOUNTS="no"/
      And the file should contain /^PRUNENAMES="foo bar baz"/
      And the file should contain /^#PRUNEPATHS="/tmp /var/spool /media /home/.encrypfs"/
      And the file should contain /^#PRUNEFS="NFS nfs nfs4 rpc_pipefs afs binfmt_misc proc smbfs autofs iso9660 ncpfs coda devpts ftpfs devfs mfs shfs sysfs cifs lustre_lite tmpfs usbfs udf fuse.glusterfs fuse.sshfs curlftpfs ecryptfs fusesmb devtmpfs"/

    Scenario: mlocate::config uninstalled
    Given a node named "class-mlocate-configs-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/updatedb.conf" should be "absent"
