Feature: apache/vhost.pp
  In order to manage apache vhosts on a system. This define must take an array
  of options to create valid virtualhost configs. It should set sane defaults
  if optional parameters aren't present.

    Scenario: apache::vhost default
    Given a node named "apache-vhost-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/apache2/sites-available/default"
      And the file should contain "VirtualHost *:80"
      And the file should contain "DocumentRoot /var/www"
      And the file should contain "<Directory /var/www>"
      And the file should contain "Options Indexes FollowSymLinks MultiViews"
    And there should be a resource "File_line[/etc/apache2/ports.conf-default-namevirtualhost-*:80]"
      And the resource should have a "line" of "NameVirtualHost *:80"
    And there should be a resource "A2site[default]"
      And the state should be "present"

    Scenario: apache::vhost redirect to ssl
    Given a node named "apache-vhost-redirect-to-ssl"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/apache2/sites-available/default"
      And the file should contain "VirtualHost *:80"
      And the file should contain "RewriteEngine On"
      And the file should contain "RewriteCond %{HTTP_HOST} (.*)"
      And the file should contain "RewriteRule ^/(.*)$ https://%1/$1"
    And there should be a resource "A2site[default]"
    And there should be a file "/etc/apache2/sites-available/default-ssl"
      And the file should contain "VirtualHost *:443"
      And the file should contain "SSLEngine On"
      And the file should contain "SSLCertificateFile /etc/ssl/certs/apache-ssl-cert.pem"
      And the file should contain "SSLCertificateKeyFile /etc/ssl/private/apache-ssl-key.key"
      And the file should contain "SSLCertificateChainFile /etc/ssl/certs/apache-ssl-chain.pem"
    And there should be a resource "A2site[default-ssl]"

    Scenario: apache::vhost non defaults
    Given a node named "apache-vhost-non-defaults"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/apache2/sites-available/25-diff-priority"
    And there should be a resource "A2site[25-diff-priority]"
    And there should be a file "/etc/apache2/sites-available/diff-srvname"
      And the file should contain "ServerName foo.bar.com"
    And there should be a resource "A2site[diff-srvname]"
    And there should be a file "/etc/apache2/sites-available/with-serveraliases-string"
      And the file should contain "ServerAlias baz.bar.com"
    And there should be a resource "A2site[with-serveraliases-string]"
    And there should be a file "/etc/apache2/sites-available/with-serveraliases-array"
      And the file should contain "ServerAlias baz.bar.com"
      And the file should contain "ServerAlias qux.bar.com"
    And there should be a resource "A2site[with-serveraliases-array]"
    And there should be a file "/etc/apache2/sites-available/with-options"
      And the file should contain "Options All"
    And there should be a resource "A2site[with-options]"
    And there should be a file "/etc/apache2/sites-available/diff-log-dir"
      And the file should contain "ErrorLog /mnt/log/apache2/diff-log-dir_error.log"
      And the file should contain "CustomLog /mnt/log/apache2/diff-log-dir_access.log combined"
    And there should be a resource "A2site[diff-log-dir]"
    And there should be a file "/etc/apache2/sites-available/diff-vhost-name"
      And the file should contain "VirtualHost foo.bar.com:80"
    And there should be a resource "File_line[/etc/apache2/ports.conf-diff-vhost-name-namevirtualhost-foo.bar.com:80]"
      And the resource should have a "line" of "NameVirtualHost foo.bar.com:80"
    And there should be a resource "A2site[diff-vhost-name]"
    And there should be a file "/etc/apache2/sites-available/diff-ports-conf"
    And there should be a resource "File_line[/etc/apache2/ports-custom.conf-diff-ports-conf-80]"
      And the resource should have a "path" of "/etc/apache2/ports-custom.conf"
      And the resource should have a "line" of "Listen 80"
    And there should be a resource "A2site[diff-ports-conf]"
    And there should be a file "/etc/apache2/sites-available/diff-template"
    And there should be a resource "A2site[diff-template]"
    And there should be a file "/etc/apache2/sites-available/diff-allow"
      And the file should contain "allow from 127.0.0.0/8"
      And the file should contain "allow from 169.254.169.0/24"

    Scenario: apache::vhost no params
    Given a node named "apache-vhost-no-params"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: apache::vhost invalid ssl boolean
    Given a node named "apache-vhost-invalid-ssl-bool"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: apache::vhost invalid redirect ssl boolean
    Given a node named "apache-vhost-invalid-redirect_ssl-bool"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: apache::vhost invalid enable boolean 
    Given a node named "apache-vhost-invalid-enable-bool"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: apache::vhost disabled
    Given a node named "apache-vhost-disabled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/apache2/sites-available/foo.bar.com"
    And there should be a resource "A2site[foo.bar.com]"
      And the state should be "absent"
