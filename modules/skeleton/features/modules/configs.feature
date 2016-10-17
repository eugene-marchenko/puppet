Feature: skeleton/configs.pp
  In order to manage skeleton services on a system. This class must install the
  configs necessary for skeleton to run.

    Scenario: skeleton::config default
    Given a node named "class-skeleton-configs-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/default/skeleton" should be "present"
    And file "/etc/skeleton/skeleton.conf" should be "present"

    Scenario: skeleton::config uninstalled
    Given a node named "class-skeleton-configs-uninstalled"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/default/skeleton" should be "absent"
    And file "/etc/skeleton/skeleton.conf" should be "absent"
