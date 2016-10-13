Feature: roles/solr/core/author.pp
  In order to setup a server with solr core author running on it, this role must
  include the main solrserver role and create necessary resources to install
  the solr author core configuration.

    Scenario: roles::solr::core::author
    Given a node named "class-roles-solr-core-author"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::solr::core::author with facts
    Given a node named "class-roles-solr-core-author"
    And a fact "jetty_listen_port" of "8983"
    And a fact "jetty_listen_address" of "0.0.0.0"
    And a fact "github_user" of "nwdb-dev"
    And a fact "github_pass" of "d@ilyb3ast"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[roles::solrserver]"
    And there should be a resource "Solr::Core[author]"
      And the resource should have a "templates" of "Template_Java,Template_Java_Solr_JMX_core_author"
      And the resource should have a "hostgroups" of "Discovered Hosts"
      And the resource should have a "port" of "10059"
      And the resource should have a "username" of "zapi"
      And the resource should have a "password" of "zappy"
    And there should be a resource "Cron::Crontab[solr_optimize_author]"
      And the resource should have a "command" of "curl 'http://localhost:8983/solr/author/update?optimize=true&waitFlush=false' >/dev/null 2>&1"
