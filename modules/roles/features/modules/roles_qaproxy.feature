Feature: roles/qaproxy.pp
  In order to setup a server that performs proxy redirects to QA/UAT instances
  for various needs such as ssl proxying, port 80 end-user needs etc.
  This class must install the necessary apache::vhost::proxy resources to do so.

    Scenario: roles::qaproxy 
    Given a node named "class-roles-qaproxy"
    When I try to compile the catalog
    Then compilation should succeed
    And there should be a resource "Class[roles::base]"
    And there should be a resource "File[/etc/ssl/certs/apache-ssl-cert-tdb.pem]"
    And there should be a resource "Apache::Vhost::Proxy[qa01.thedailybeast.com]"
    And there should be a resource "Apache::Vhost::Proxy[qa01.thedailybeast.com_6081]"
    And there should be a resource "Apache::Vhost::Proxy[qa01.thedailybeast.com_443]"
      And the resource should have a "ssl_cert" of "/etc/ssl/certs/apache-ssl-cert-tdb.pem"
    And there should be a resource "Apache::Vhost::Proxy[qa02.thedailybeast.com]"
    And there should be a resource "Apache::Vhost::Proxy[qa02.thedailybeast.com_6081]"
    And there should be a resource "Apache::Vhost::Proxy[qa02.thedailybeast.com_443]"
      And the resource should have a "ssl_cert" of "/etc/ssl/certs/apache-ssl-cert-tdb.pem"
    And there should be a resource "Apache::Vhost::Proxy[qa03.thedailybeast.com]"
    And there should be a resource "Apache::Vhost::Proxy[qa03.thedailybeast.com_6081]"
    And there should be a resource "Apache::Vhost::Proxy[qa03.thedailybeast.com_443]"
      And the resource should have a "ssl_cert" of "/etc/ssl/certs/apache-ssl-cert-tdb.pem"
    And there should be a resource "Apache::Vhost::Proxy[uat.thedailybeast.com_80]"
    And there should be a resource "Apache::Vhost::Proxy[uat.thedailybeast.com_443]"
      And the resource should have a "ssl_cert" of "/etc/ssl/certs/apache-ssl-cert-tdb.pem"
