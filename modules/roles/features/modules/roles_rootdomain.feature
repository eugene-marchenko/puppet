Feature: roles/rootdomain.pp
  In order to setup a server that performs rootdomain redirects to subdomains
  due to the limitations inherent with ephermeral IPs on AWS. This class
  must install the necessary apache::vhost::redirect resources to redirect
  sites to www.

    Scenario: roles::rootdomain 
    Given a node named "class-roles-rootdomain"
    When I try to compile the catalog
    Then compilation should succeed
    And there should be a resource "Class[roles::base]"
    And there should be a resource "Apache::Vhost::Redirect[newsweekdailybeast.com]"
    And there should be a resource "Apache::Vhost::Redirect[dailybeast.com]"
    And there should be a resource "Apache::Vhost::Redirect[havingtroublevoting.com]"
    And there should be a resource "Apache::Vhost::Redirect[thisisyourreponguns.com]"
    And there should be a resource "Apache::Vhost::Redirect[author.ec2.newsweek.com_80]"
    And there should be a resource "Apache::Vhost::Redirect[author.ec2.newsweek.com_443]"
