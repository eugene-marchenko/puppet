Feature: roles/swap.pp
  In order for servers to have enough memory to run their applications. This
  class will create a swapfile with the necessary space to do so.

    Scenario: roles::swap default
    Given a node named "class-roles-swap"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And exec "/mnt/swap" should be present
    And exec "swapon /mnt/swap" should be present
