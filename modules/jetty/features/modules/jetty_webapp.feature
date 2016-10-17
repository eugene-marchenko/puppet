Feature: jetty/webapp.pp
  In order to manage webapps for jetty. This define must take a config and a
  warfile and deploy them to the system. It should be able to install/enable/
  uninstall/disable the webapp. It should be able to take a puppet filebucketed
  resource, an http web resource or a template resource as the file contents for
  both config and webapps.

    Scenario: jetty::webapp web install
    Given a node named "jetty-webapp-web"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/jetty/jetty-jmx.xml"
    And there should be a file "/usr/share/jetty/webapps/zapcat-1.2.war"
    And there should be a file "/etc/jetty/foo.html"
    And there should be a file "/usr/share/jetty/webapps/warfile.war"

    Scenario: jetty::webapp webssl install
    Given a node named "jetty-webapp-webssl"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/jetty/jetty-jmx.xml"
    And there should be a file "/usr/share/jetty/webapps/zapcat-1.2.war"

    Scenario: jetty::webapp filebucket install
    Given a node named "jetty-webapp-filebucket"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/etc/jetty/config.xml"
    And there should be a file "/usr/share/jetty/webapps/warfile.war"

    Scenario: jetty::webapp disabled
    Given a node named "jetty-webapp-disabled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/jetty/config.xml" should be "absent"
    And there should be a file "/usr/share/jetty/webapps/warfile.war"

    Scenario: jetty::webapp uninstalled
    Given a node named "jetty-webapp-uninstalled"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/jetty/config.xml" should be "absent"
    And file "/usr/share/jetty/webapps/warfile.war" should be "absent"

    Scenario: jetty::webapp invalid http
    Given a node named "jetty-webapp-invalid-http"
    When I try to compile the catalog
    Then compilation should fail

    Scenario: jetty::webapp no params
    Given a node named "jetty-webapp-no-params"
    When I try to compile the catalog
    Then compilation should fail
