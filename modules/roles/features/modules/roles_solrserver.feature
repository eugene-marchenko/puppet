Feature: roles/solrserver.pp
  In order to setup a server with solr running on it, this role must create the
  necessary resources to install solr, a servlet engine for it to run on, and
  any additional resources necessary for solr to run.

    Scenario: roles::solrserver
    Given a node named "class-roles-solrserver"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: roles::solrserver with facts
    Given a node named "class-roles-solrserver"
    And a fact "jetty_listen_port" of "8983"
    And a fact "jetty_listen_address" of "0.0.0.0"
    And a fact "github_user" of "nwdb-dev"
    And a fact "github_pass" of "d@ilyb3ast"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Apt::Source[solr-3.3]"
    And there should be a resource "Class[java]"
      And the resource should have a "templates" of "Template_Java,Template_Java_Solr_JMX"
      And the resource should have a "hostgroups" of "Discovered Hosts"
      And the resource should have a "port" of "10059"
      And the resource should have a "username" of "zapi"
      And the resource should have a "password" of "zappy"
    And there should be a resource "Class[jetty]"
    And there should be a resource "Class[jetty::service]"
    And there should be a resource "File[/mnt/log/jetty]"
    And there should be a resource "File[/var/log/jetty]"
    And there should be a resource "Jetty::Webapp[zapcat]"
    And there should be a resource "Class[solr]"
    And there should be a file "/etc/solr/conf/schema.xml"
    And there should be a file "/etc/solr/conf/solrconfig.xml"
    And there should be a resource "Cron::Crontab[solr_optimize]"
      And the resource should have a "command" of "curl 'http://localhost:8983/solr/update?optimize=true&waitFlush=false' >/dev/null 2>&1"

    Scenario: roles::solrserver in prod env with author and publish
    Given a node named "class-roles-solrserver"
    And a fact "env" of "prod"
    And a fact "roles" of "author, publisher"
    And a fact "jetty_listen_port" of "8983"
    And a fact "jetty_listen_address" of "0.0.0.0"
    And a fact "github_user" of "nwdb-dev"
    And a fact "github_pass" of "d@ilyb3ast"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Apt::Source[solr-3.3]"
    And there should be a resource "Class[java]"
      And the resource should have a "dns" of "class-roles-solrserver"
      And the resource should have a "templates" of "Template_Java,Template_Java_Solr_JMX"
      And the resource should have a "hostgroups" of "Prod Publish Servers,Prod Author Servers"
      And the resource should have a "port" of "10059"
      And the resource should have a "username" of "zapi"
      And the resource should have a "password" of "zappy"
    And there should be a resource "Class[jetty]"
    And there should be a resource "Class[jetty::service]"
    And there should be a resource "File[/mnt/log/jetty]"
    And there should be a resource "File[/var/log/jetty]"
    And there should be a resource "Jetty::Webapp[zapcat]"
    And there should be a resource "Class[solr]"
    And there should be a file "/etc/solr/conf/schema.xml"
    And there should be a file "/etc/solr/conf/solrconfig.xml"
    And there should be a resource "Cron::Crontab[solr_optimize]"
      And the resource should have a "command" of "curl 'http://localhost:8983/solr/update?optimize=true&waitFlush=false' >/dev/null 2>&1"

    Scenario: roles::solrserver in uat env with just author
    Given a node named "class-roles-solrserver"
    And a fact "env" of "uat"
    And a fact "roles" of "author"
    And a fact "jetty_listen_port" of "8983"
    And a fact "jetty_listen_address" of "0.0.0.0"
    And a fact "github_user" of "nwdb-dev"
    And a fact "github_pass" of "d@ilyb3ast"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Apt::Source[solr-3.3]"
    And there should be a resource "Class[java]"
      And the resource should have a "dns" of "class-roles-solrserver"
      And the resource should have a "templates" of "Template_Java,Template_Java_Solr_JMX"
      And the resource should have a "hostgroups" of "UAT Author Servers"
      And the resource should have a "port" of "10059"
      And the resource should have a "username" of "zapi"
      And the resource should have a "password" of "zappy"
    And there should be a resource "Class[jetty]"
    And there should be a resource "Class[jetty::service]"
    And there should be a resource "File[/mnt/log/jetty]"
    And there should be a resource "File[/var/log/jetty]"
    And there should be a resource "Jetty::Webapp[zapcat]"
    And there should be a resource "Class[solr]"
    And there should be a file "/etc/solr/conf/schema.xml"
    And there should be a file "/etc/solr/conf/solrconfig.xml"
    And there should be a resource "Cron::Crontab[solr_optimize]"
      And the resource should have a "command" of "curl 'http://localhost:8983/solr/update?optimize=true&waitFlush=false' >/dev/null 2>&1"

    Scenario: roles::solrserver in qa env
    Given a node named "class-roles-solrserver"
    And a fact "env" of "qa"
    And a fact "roles" of "author,publisher,collapsed_stack"
    And a fact "jetty_listen_port" of "8983"
    And a fact "jetty_listen_address" of "0.0.0.0"
    And a fact "github_user" of "nwdb-dev"
    And a fact "github_pass" of "d@ilyb3ast"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Apt::Source[solr-3.3]"
    And there should be a resource "Class[java]"
      And the resource should have a "dns" of "class-roles-solrserver"
      And the resource should have a "templates" of "Template_Java,Template_Java_Solr_JMX"
      And the resource should have a "hostgroups" of "QA Servers"
      And the resource should have a "port" of "10059"
      And the resource should have a "username" of "zapi"
      And the resource should have a "password" of "zappy"
    And there should be a resource "Class[jetty]"
    And there should be a resource "Class[jetty::service]"
    And there should be a resource "File[/mnt/log/jetty]"
    And there should be a resource "File[/var/log/jetty]"
    And there should be a resource "Jetty::Webapp[zapcat]"
    And there should be a resource "Class[solr]"
    And there should be a file "/etc/solr/conf/schema.xml"
    And there should be a file "/etc/solr/conf/solrconfig.xml"
    And there should be a resource "Cron::Crontab[solr_optimize]"
      And the resource should have a "command" of "curl 'http://localhost:8983/solr/update?optimize=true&waitFlush=false' >/dev/null 2>&1"
