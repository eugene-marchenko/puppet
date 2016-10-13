Feature: roles/cq5/author/secure_cache.pp
  In order to setup a cq5 secure author server cache, this role must create the
  necessary resources to run an apache redirect to ssl vhost and a dispatcher
  vhost running on ssl back to the cq5 author.

    Scenario: roles::cq5::author::secure_cache
    Given a node named "class-roles-cq5-author-secure_cache"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::base]"
    And there should be a resource "Class[apache]"
    And there should be a resource "Class[apache::dispatcher]"
    And there should be a resource "Apache::Vhost[default]"
      And the resource should have "enable" set to "false"
    And there should be a resource "Apache::Vhost[test.local_80]"
      And the resource should have a "servername" of "test.local"
      And the resource should have a "priority" of "05"
    And there should be a resource "Apache::Dispatcher::Vhost[test.local_443]"
      And the resource should have a "servername" of "test.local"
      And the resource should have a "priority" of "05"
      And the resource should have a "d_tmpl_priority" of "30"
      And the resource should have a "d_tmpl" of "apache/dispatcher/author-vhost.any.erb"
      And the resource should have a "ssl_cert" of "/etc/ssl/certs/apache-ssl-cert.pem"
    And file "/_etc_apache2_dispatcher.any/fragments/0__etc_apache2_dispatcher.any_head" should be "present"
    And file "/_etc_apache2_dispatcher.any/fragments/30__etc_apache2_dispatcher.any_test.local_443" should be "present"
      And the file should contain /    \/rend0 \{ \/hostname "test.local" \/port "8080" \/timeout "30000" \}/
    And there should be a resource "File[/var/www/robots.txt]"
      And the file should contain /User-Agent \*\nDisallow \/\n/

    Scenario: roles::cq5::author::secure_cache with optional facts
    Given a node named "class-roles-cq5-author-secure_cache"
    And a fact "cq5_author_port" of "4502"
    And a fact "cq5_author_hostname" of "author-test.local"
    And a fact "cq5_author_ssl_cert" of "/tmp/foo.crt"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::base]"
    And there should be a resource "Class[apache]"
    And there should be a resource "Class[apache::dispatcher]"
    And there should be a resource "Apache::Vhost[default]"
      And the resource should have "enable" set to "false"
    And there should be a resource "Apache::Vhost[author-test.local_80]"
      And the resource should have a "servername" of "author-test.local"
      And the resource should have a "priority" of "05"
    And there should be a resource "Apache::Dispatcher::Vhost[author-test.local_443]"
      And the resource should have a "servername" of "author-test.local"
      And the resource should have a "priority" of "05"
      And the resource should have a "d_tmpl_priority" of "30"
      And the resource should have a "d_tmpl" of "apache/dispatcher/author-vhost.any.erb"
      And the resource should have a "ssl_cert" of "/tmp/foo.crt"
    And file "/_etc_apache2_dispatcher.any/fragments/0__etc_apache2_dispatcher.any_head" should be "present"
    And file "/_etc_apache2_dispatcher.any/fragments/30__etc_apache2_dispatcher.any_author-test.local_443" should be "present"
      And the file should contain /    \/rend0 \{ \/hostname "author-test.local" \/port "4502" \/timeout "30000" \}/
    And there should be a resource "File[/var/www/robots.txt]"
      And the file should contain /User-Agent \*\nDisallow \/\n/
