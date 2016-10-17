Feature: apache/vhost.pp
  In order to manage apache vhost proxies on a system. This define must take an
  array of options to create valid virtualhost configs. It should set sane
  defaults if optional parameters aren't present.

    Scenario: apache::vhost::proxy default
    Given a node named "apache-proxy-default"
    When I compile the catalog
    Then compilation should succeed
    And there should be a file "/etc/apache2/sites-available/foo.bar.com"    
      And the file should contain "ProxyPass / http://foo.bar.com:8080/"
      And the file should contain "ProxyPassReverse / http://foo.bar.com:8080"
      And the file should contain "ProxyPreserveHost On"
      And the file should contain "RequestHeader set X-Forwarded-Port 80"
      And the file should contain "RequestHeader set X-Forwarded-Proto http"
    And there should be a resource "A2mod[proxy_http]"
    And there should be a resource "A2mod[headers]"

    Scenario: apache::vhost::proxy ssl
    Given a node named "apache-proxy-ssl"
    When I compile the catalog
    Then compilation should succeed
    And there should be a file "/etc/apache2/sites-available/foo.bar.com"
      And the file should contain "SSLEngine On"
      And the file should contain "SSLCertificateFile /etc/ssl/certs/apache-ssl-cert.pem"
      And the file should contain "SSLCertificateKeyFile /etc/ssl/private/apache-ssl-key.key"
      And the file should contain "SSLCertificateChainFile /etc/ssl/certs/apache-ssl-chain.pem"
      And the file should contain "RequestHeader set X-Forwarded-Port 443"
      And the file should contain "RequestHeader set X-Forwarded-Proto https"
    And there should be a resource "A2mod[proxy_http]"
    And there should be a resource "A2mod[headers]"

    Scenario: apache::vhost::proxy proxy deny
    Given a node named "apache-proxy-deny"
    When I compile the catalog
    Then compilation should succeed
    And there should be a file "/etc/apache2/sites-available/foo.bar.com"
      And the file should contain "ProxyPass /robots.txt !"
      And the file should contain "ProxyPass / http://foo.bar.com:8080/"
      And the file should contain "ProxyPassReverse / http://foo.bar.com:8080/"
    And there should be a file "/etc/apache2/sites-available/baz.bar.com"
      And the file should contain "ProxyPass /robots.txt !"
      And the file should contain "ProxyPass /favicon.ico !"
      And the file should contain "ProxyPass / http://foo.bar.com:8080/"
      And the file should contain "ProxyPassReverse / http://foo.bar.com:8080/"
    And there should be a resource "A2mod[proxy_http]"
    And there should be a resource "A2mod[headers]"

    Scenario: apache::vhost::proxy no preserve host
    Given a node named "apache-proxy-no-preserve-host"
    When I compile the catalog
    Then compilation should succeed
    And there should be a file "/etc/apache2/sites-available/foo.bar.com"
      And the file should contain "ProxyPreserveHost Off"

    Scenario: apache::vhost::proxy with proxy authentication
    Given a node named "apache-proxy-with-auth"
    When I compile the catalog
    Then compilation should succeed
    And there should be a file "/etc/apache2/sites-available/foo.bar.com"
      And the file should contain "AuthType Basic"
      And the file should contain /AuthName "Password Required"/
      And the file should contain "AuthUserFile /etc/apache2/password.file"
      And the file should contain "Require valid-user"
    And there should be a file "/etc/apache2/sites-available/baz.bar.com"
      And the file should contain "AuthType ldap"
      And the file should contain /AuthName "foo"/
      And the file should contain "AuthUserFile /var/www/baz.bar.com/pw.file"
      And the file should contain "Require valid-user"

    Scenario: apache::vhost::proxy with custom headers
    Given a node named "apache-proxy-custom-headers"
    When I compile the catalog
    Then compilation should succeed
    And there should be a file "/etc/apache2/sites-available/foo.bar.com"
      And the file should contain "Header set MyHeader Hello"
      And the file should contain "Header unset Set-Cookie"
      And the file should contain "RequestHeader set Foo Bar"
      And the file should contain "RequestHeader set Baz:Qux"
      And the file should contain "RequestHeader set X-Forwarded-Port 80"
      And the file should contain "RequestHeader set X-Forwarded-Proto http"
      And the file should contain "RequestHeader unset Cookie"

    Scenario: apache::vhost::proxy no params
    Given a node named "apache-proxy-no-params"
    When I try to compile the catalog
    Then compilation should fail
