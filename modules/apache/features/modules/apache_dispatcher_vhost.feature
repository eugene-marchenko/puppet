Feature: apache/dispatcher/vhost.pp
  In order to manage apache dispatcher vhosts on a system. The apache dispatcher
  vhost define must take a list of parameters and create a virtualhost. It should
  set sane defaults for all optional parameters.

  Scenario: apache dispatcher vhost with default vhost
  Given a node named "apache-dispatcher-vhost-default-vhost"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/apache2/mods-available/dispatcher.load"
  And there should be a file "/etc/apache2/mods-available/dispatcher.conf"
    And the file should contain "DispatcherLog /var/log/apache2/dispatcher.log"
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
  And there should be a resource "A2mod[rewrite]"
    And the state should be "present"
  And there should be a resource "A2mod[expires]"
    And the state should be "present"
  And there should be a resource "A2mod[deflate]"
    And the state should be "present"
  And there should be a resource "Concat[/etc/apache2/dispatcher.any]"
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_head]"
    And the resource should have an "order" of "0"
    And the resource should have a "target" of "/etc/apache2/dispatcher.any"
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_tail]"
    And the resource should have an "order" of "99"
    And the resource should have a "target" of "/etc/apache2/dispatcher.any"
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_www.example.com]"
    And the resource should have an "order" of "10"
    And the resource should have a "target" of "/etc/apache2/dispatcher.any"
  And there should be a file "/etc/apache2/sites-available/000-www.example.com"
    And the file should contain "VirtualHost *:80"
    And the file should contain "DocumentRoot /mnt/dispatcher/www.example.com"
    And the file should contain "ServerName www.example.com"
    And the file should contain "ServerAlias *.www.example.com"
    And the file should contain "ServerAlias *.example.*"
  And file "/_etc_apache2_dispatcher.any/fragments/10__etc_apache2_dispatcher.any_www.example.com" should be "present"
    And the file should contain "/www_example_com"
    And the file should contain /virtualhosts\n  \{\n        "\*"\n    \}\n/
    And the file should contain /    \/rend0 \{ \/hostname "rend01.example.com" \/port "8080" \/timeout "30000" \}/
    And the file should contain /    \/rend1 \{ \/hostname "rend02.example.com" \/port "80" \/timeout "30000" \}/
    And the file should contain /  \/docroot "\/mnt\/dispatcher\/www.example.com"/
  And there should be a resource "A2site[000-www.example.com]"
    And the state should be "present"

  Scenario: apache dispatcher vhost with two vhosts
  Given a node named "apache-dispatcher-vhost-two-vhosts"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a file "/etc/apache2/mods-available/dispatcher.load"
  And there should be a file "/etc/apache2/mods-available/dispatcher.conf"
    And the file should contain "DispatcherLog /var/log/apache2/dispatcher.log"
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
  And there should be a resource "A2mod[rewrite]"
    And the state should be "present"
  And there should be a resource "A2mod[expires]"
    And the state should be "present"
  And there should be a resource "A2mod[deflate]"
    And the state should be "present"
  And there should be a resource "Concat[/etc/apache2/dispatcher.any]"
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_head]"
    And the resource should have an "order" of "0"
    And the resource should have a "target" of "/etc/apache2/dispatcher.any"
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_tail]"
    And the resource should have an "order" of "99"
    And the resource should have a "target" of "/etc/apache2/dispatcher.any"
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_www.example.com]"
    And the resource should have an "order" of "10"
    And the resource should have a "target" of "/etc/apache2/dispatcher.any"
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_services.example.com]"
    And the resource should have an "order" of "15"
    And the resource should have a "target" of "/etc/apache2/dispatcher.any"
  And there should be a file "/etc/apache2/sites-available/000-www.example.com"
    And the file should contain "VirtualHost *:443"
    And the file should contain "DocumentRoot /mnt/dispatcher/www.example.com"
    And the file should contain "ServerName www.example.com"
    And the file should contain "ServerAlias *.www.example.com"
    And the file should contain "ServerAlias example.*"
  And file "/_etc_apache2_dispatcher.any/fragments/10__etc_apache2_dispatcher.any_www.example.com" should be "present"
    And the file should contain "/www_example_com"
    And the file should contain /virtualhosts\n  \{\n        "\*"\n    \}\n/
    And the file should contain /    \/rend0 \{ \/hostname "rend01.example.com" \/port "8080" \/timeout "30000" \}/
    And the file should contain /    \/rend1 \{ \/hostname "rend02.example.com" \/port "80" \/timeout "30000" \}/
  And there should be a file "/etc/apache2/sites-available/05-services.example.com"
    And the file should contain "VirtualHost *:80"
    And the file should contain "DocumentRoot /mnt/dispatcher/services.example.com"
    And the file should contain "ServerName services.example.com"
    And the file should contain "ServerAlias *.services.example.*"
  And file "/_etc_apache2_dispatcher.any/fragments/15__etc_apache2_dispatcher.any_services.example.com" should be "present"
    And the file should contain "/services_example_com"
    And the file should contain /virtualhosts\n  \{\n        "services.example.com"\n    \}\n/
    And the file should contain /    \/rend0 \{ \/hostname "rend03.example.com" \/port "8080" \/timeout "30000" \}/
    And the file should contain /    \/rend1 \{ \/hostname "rend03.example.com" \/port "8081" \/timeout "30000" \}/
    And the file should contain /    \/rend2 \{ \/hostname "rend04.example.com" \/port "8080" \/timeout "30000" \}/
    And the file should contain /    \/rend3 \{ \/hostname "rend04.example.com" \/port "8081" \/timeout "30000" \}/
  And there should be a resource "A2site[000-www.example.com]"
    And the state should be "present"
  And there should be a resource "A2site[05-services.example.com]"
    And the state should be "present"

  Scenario: apache dispatcher vhost disable vhost
  Given a node named "apache-dispatcher-vhost-disabled-vhost"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And there should be a resource "Concat::Fragment[/etc/apache2/dispatcher.any_www.example.com]"
    And the state should be "absent"
  And there should be a resource "A2site[000-www.example.com]"
    And the state should be "absent"
