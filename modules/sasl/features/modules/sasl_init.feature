Feature: sasl/init.pp
  In order to manage sasl on a system. The sasl class should by default
  install the sasl package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: sasl default
  Given a node named "class-sasl-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/default/saslauthd"
    And the file should contain /OPTIONS=\"-c -m /var/run/saslauthd\"/
  And file "/etc/sasldb2" should be "present"
  And there should be a resource "File[/var/run/saslauthd]"
    And the resource should have an "ensure" of "directory"
    And the resource should have a "group" of "sasl"
  And following packages should be dealt with:
    | name              | state   |
    | sasl2-bin         | latest  |
    | libgsasl7         | latest  |
    | libsasl2-2        | latest  |
    | libsasl2-modules  | latest  |
  And service "saslauthd" should be "stopped"
  And there should be no resource "User[postfix-sasl]"

  Scenario: sasl postfix installed
  Given a node named "class-sasl-postfix-installed"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/default/saslauthd"
    And the file should contain /OPTIONS=\"-c -m /var/run/saslauthd\"/
  And file "/etc/sasldb2" should be "present"
  And there should be a resource "File[/var/run/saslauthd]"
    And the resource should have an "ensure" of "directory"
    And the resource should have a "group" of "sasl"
  And following packages should be dealt with:
    | name              | state   |
    | sasl2-bin         | latest  |
    | libgsasl7         | latest  |
    | libsasl2-2        | latest  |
    | libsasl2-modules  | latest  |
  And service "saslauthd" should be "stopped"
  And there should be a resource "User[postfix-sasl]"

  Scenario: sasl removed
  Given a node named "class-sasl-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
    | name              | state   |
    | sasl2-bin         | purged  |
    | libgsasl7         | purged  |
    | libsasl2-2        | purged  |
    | libsasl2-modules  | purged  |
  And there should be no resource "File[/etc/default/saslauthd]"
  And there should be no resource "File[/etc/sasldb]"
  And there should be no resource "File[/var/run/saslauthd]"
  And there should be no resource "Service[saslauthd]"
