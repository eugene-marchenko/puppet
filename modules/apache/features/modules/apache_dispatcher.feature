Feature: apache/dispatcher.pp
  In order to manage apache dispatcher on a system. The apache dispatcher class
  install common files and enable common modules for dispatcher enabled vhosts
  to run.

  Scenario: apache dispatcher default
  Given a node named "class-apache-dispatcher-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/apache2/mods-available/dispatcher.load"
  And there should be a file "/etc/apache2/mods-available/dispatcher.conf"
    And the file should contain "DispatcherConfig /etc/apache2/dispatcher.any"
    And the file should contain "DispatcherLog /var/log/apache2/dispatcher.log"
    And the file should contain "DispatcherLogLevel 0"
    And the file should contain "DispatcherNoServerHeader 0"
    And the file should contain "DispatcherDeclineRoot 0"
    And the file should contain "DispatcherUseProcessedURL 1"
    And the file should contain "DispatcherPassError 1"
  And there should be a file "/usr/lib/apache2/modules/mod_dispatcher.so"
  And there should be a file "/var/www/errors/404.html"
  And there should be a file "/var/www/ping.txt"
    And the file should contain "pong..."
  And there should be a resource "File[/var/log/apache2]"
    And the state should be "directory"
    And the resource should have an "owner" of "root"
    And the resource should have a "group" of "adm"
    And the resource should have a "mode" of "0750"
  And following directories should be created:
    | name                  |
    | /mnt/dispatcher       |
    | /var/www/errors       |
  And there should be a resource "A2mod[dispatcher]"
    And the state should be "present"
  And there should be a resource "A2mod[headers]"
    And the state should be "present"
  And there should be a resource "Concat[/etc/apache2/dispatcher.any]"
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_head]"
    And the resource should have an "order" of "0"
    And the resource should have a "target" of "/etc/apache2/dispatcher.any"
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_tail]"
    And the resource should have an "order" of "99"
    And the resource should have a "target" of "/etc/apache2/dispatcher.any"

  Scenario: apache dispatcher from facts
  Given a node named "class-apache-dispatcher-default"
  And a fact "apache_log_dir" of "/mnt/log/apache2"
  And a fact "apache_dispatcher_conf" of "/etc/apache2/config.any"
  And a fact "apache_dispatcher_log" of "foo.log"
  And a fact "apache_dispatcher_log_level" of "0"
  And a fact "apache_dispatcher_no_server_header" of "1"
  And a fact "apache_dispatcher_decline_root" of "1"
  And a fact "apache_dispatcher_use_processed_url" of "0"
  And a fact "apache_dispatcher_pass_error" of "0"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/apache2/mods-available/dispatcher.load"
  And there should be a file "/etc/apache2/mods-available/dispatcher.conf"
    And the file should contain "DispatcherConfig /etc/apache2/config.any"
    And the file should contain "DispatcherLog /mnt/log/apache2/foo.log"
    And the file should contain "DispatcherLogLevel 3"
    And the file should contain "DispatcherNoServerHeader 1"
    And the file should contain "DispatcherDeclineRoot 1"
    And the file should contain "DispatcherUseProcessedURL 0"
    And the file should contain "DispatcherPassError 0"
  And there should be a file "/usr/lib/apache2/modules/mod_dispatcher.so"
  And there should be a file "/var/www/errors/404.html"
  And there should be a file "/var/www/ping.txt"
    And the file should contain "pong..."
  And there should be a resource "File[/mnt/log/apache2]"
    And the state should be "directory"
    And the resource should have an "owner" of "root"
    And the resource should have a "group" of "adm"
    And the resource should have a "mode" of "0750"
  And following directories should be created:
    | name                  |
    | /mnt/dispatcher       |
    | /var/www/errors       |
  And there should be a resource "A2mod[dispatcher]"
    And the state should be "present"
  And there should be a resource "A2mod[headers]"
    And the state should be "present"
  And there should be a resource "Concat[/etc/apache2/config.any]"
  And there should be a resource "Concat::Fragment[/etc/apache2/config.any_head]"
    And the resource should have an "order" of "0"
    And the resource should have a "target" of "/etc/apache2/config.any"
  And there should be a resource "Concat::Fragment[/etc/apache2/config.any_tail]"
    And the resource should have an "order" of "99"
    And the resource should have a "target" of "/etc/apache2/config.any"

  Scenario: apache dispatcher uninstalled
  Given a node named "class-apache-dispatcher-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a resource "A2mod[dispatcher]"
    And the state should be "absent"
  And there should be a resource "Concat[/etc/apache2/dispatcher.any]"
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_head]"
    And the resource should have an "order" of "0"
    And the resource should have a "target" of "/etc/apache2/dispatcher.any"
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_tail]"
    And the resource should have an "order" of "99"
    And the resource should have a "target" of "/etc/apache2/dispatcher.any"
