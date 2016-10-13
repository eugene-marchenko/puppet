Feature: roles/cq5/author/secure.pp
  In order to setup a cq5 secure author server, this role must create the
  necessary resources to run an apache ssl vhost proxy back to the cq5 author.

    Scenario: roles::cq5::author::secure
    Given a node named "class-roles-cq5-author-secure"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::base]"
    And there should be a resource "Class[apache]"
    And there should be a resource "Apache::Vhost[default]"
      And the resource should have "enable" set to "false"
    And there should be a resource "Apache::Vhost[test.local_80]"
      And the resource should have a "servername" of "test.local"
      And the resource should have a "priority" of "15"
    And there should be a resource "Apache::Vhost::Proxy[test.local_443]"
      And the resource should have a "servername" of "test.local"
      And the resource should have a "priority" of "15"
      And the resource should have a "dest" of "http://test.local:8080"
      And the resource should have a "ssl_cert" of "/etc/ssl/certs/apache-ssl-cert.pem"
    And there should be a resource "File[/var/www/robots.txt]"
      And the file should contain /User-Agent \*\nDisallow \/\n/

    Scenario: roles::cq5::author::secure with optional facts
    Given a node named "class-roles-cq5-author-secure"
    And a fact "cq5_author_port" of "4502"
    And a fact "cq5_author_hostname" of "author-test.local"
    And a fact "cq5_author_ssl_cert" of "/tmp/foo.crt"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::base]"
    And there should be a resource "Class[apache]"
    And there should be a resource "Apache::Vhost[default]"
      And the resource should have "enable" set to "false"
    And there should be a resource "Apache::Vhost[author-test.local_80]"
      And the resource should have a "servername" of "author-test.local"
      And the resource should have a "priority" of "15"
    And there should be a resource "Apache::Vhost::Proxy[author-test.local_443]"
      And the resource should have a "dest" of "http://author-test.local:4502"
      And the resource should have a "servername" of "author-test.local"
      And the resource should have a "priority" of "15"
      And the resource should have a "ssl_cert" of "/tmp/foo.crt"
    And there should be a resource "File[/var/www/robots.txt]"
      And the file should contain /User-Agent \*\nDisallow \/\n/
