Feature: mailalias.pp
  In order to have mail aliases, the mailalias define should
  create aliases to recipients on the system.

    Scenario: Define postfix::mailalias with one alias
    Given a node named "define-mailalias-one-alias"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And the mailalias "root" should be created
      And the mailalias should be pointed to "webops@thedailybeast.com"

    Scenario: Define postfix::mailalias with multiple alias
    Given a node named "define-mailalias-multiple-alias"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And the mailalias "root" should be created
      And the mailalias should be pointed to "webops@thedailybeast.com"
    And exec "newaliases-root" should be present
    And the mailalias "foo" should be created
      And the mailalias should be pointed to "webops@thedailybeast.com"
    And exec "newaliases-foo" should be present

    Scenario: Define postfix::mailalias with alias absent
    Given a node named "define-mailalias-alias-absent"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And the mailalias "root" should be absent
    And exec "newaliases-root" should be present

    Scenario: Define postfix::mailalias should fail
    Given a node named "define-mailalias-should-fail"
    When I try to compile the catalog
    Then compilation should fail
