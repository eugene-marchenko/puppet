Feature: vsftpd/init.pp
  In order to manage vsftpd on a system. The vsftpd class should by default
  install the vsftpd package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: vsftpd default
  Given a node named "class-vsftpd-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/vsftpd.conf" should be "present"
  And file "/etc/default/vsftpd" should be "present"
  And following directories should be created:
    | name          |
    | /etc/vsftpd.d |
  And file "/etc/vsftpd.d/vsftpd.chroot_users" should be "present"
  And file "/etc/vsftpd.d/vsftpd.banned_emails" should be "present"
  And file "/etc/vsftpd.d/vsftpd.email_passwords" should be "present"
  And file "/etc/vsftpd.d/vsftpd.userlist_file" should be "present"
  And following packages should be dealt with:
    | name  | state   |
    | vsftpd | latest  |
  And service "vsftpd" should be "running"

  Scenario: vsftpd removed
  Given a node named "class-vsftpd-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
  | name  | state   |
  | vsftpd | purged  |
  And there should be no resource "File[/etc/vsftpd/vsftpd.conf]"
  And there should be no resource "File[/etc/default/vsftpd]"
  And there should be no resource "File[/etc/vsftpd.d/vsftpd.chroot_users]"
  And there should be no resource "File[/etc/vsftpd.d/vsftpd.banned_emails]"
  And there should be no resource "File[/etc/vsftpd.d/vsftpd.email_passwords]"
  And there should be no resource "File[/etc/vsftpd.d/vsftpd.userlist_file]"
  And there should be no resource "Service[vsftpd]"
