Feature: apache/vhost/default.pp
  In order to manage the default apache vhost on systems which have multiple
  classes needing to manage it. Create the resource as a virtual resource
  so the other classes can then realize it and thus avoid duplicate definitions.

    Scenario: apache::vhost::default::vhost default
    Given a node named "apache-vhost-default-vhost"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be no resource "Apache::Vhost[default]"

    Scenario: apache::vhost::default::vhost realized
    Given a node named "apache-vhost-default-vhost-realized"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Apache::Vhost[default]"
      And the resource should have "enable" set to "false"
