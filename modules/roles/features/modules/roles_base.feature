Feature: roles/base.pp
  In order for servers to bootstrap properly, the base role class must install
  basic packages that all servers need.

    Scenario: roles::base default (with no facts)
    Given a node named "class-roles-base"
    And without fact "fqdn"
    And without fact "route53_aws_access_key"
    And without fact "route53_aws_secret_access_key"
    And without fact "aws_snapshotter_access_key"
    And without fact "aws_snapshotter_secret_key"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::base default with facts
    Given a node named "class-roles-base"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[dhcp]"
    And there should be a resource "Class[lvm2]"
    And there should be a resource "Class[hosts]"
    And there should be a resource "Hosts::Manage[meta-data]"
      And the resource should have an "ip" of "169.254.169.254"
    And there should be a resource "Class[ntp]"
    And there should be a resource "Class[cron]"
    And there should be a resource "Class[mlocate]"
    And there should be a resource "Class[build]"
    And there should be a resource "Class[build::devlibs]"
    And there should be a resource "Class[python]"
    And there should be a resource "Class[python::pip::packages]"
    And there should be a resource "Class[route53]"
    And there should be a resource "Class[ruby]"
    And there should be a resource "Class[ruby::gem::packages]"
    And there should be a resource "Class[monit]"
    And there should be a resource "Class[logwatch]"
    And there should be a resource "Class[logrotate]"
    And there should be a resource "Class[git]"
    And there should be a resource "Class[shells]"
    And there should be a resource "Class[sysctl]"
    And there should be a resource "Class[rsyslog]"
    And there should be a resource "Class[users]"
    And there should be a resource "Class[sudo]"
    And there should be a resource "File[/mnt/log]"
    And there should be a resource "Mailalias[root]"
    And there should be a resource "Python::Package[python-dateutil]"
    And there should be a resource "Class[aws::ec2::ebs::snapshot]"
    And there should be a resource "Cron::Crontab[ebs_snapshot]"
      And the resource should have a "command" of "sync && /usr/local/bin/ebs-snapshot.py -r us-east-1 -t 1m instance -i i-123456"
    And file "/etc/sudoers.d/10-defaults-insults" should be "present"
      And the file should contain "Defaults insults"
    And group "sysadmins" should be "present"
    And user "harvey" should be "present"
    And user "mike" should be "present"
    And file "/etc/sudoers.d/sysadmins" should be "present"
    And package "popularity-contest" should be "absent"
    And there should be a resource "File[/var/log/upstart]"
      And the resource should have an "ensure" of "directory"
