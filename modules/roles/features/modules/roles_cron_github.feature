Feature: roles/cron/github.pp
  In order to run the github cronjobs for various tasks. This package must
  install the necessary resources to run the specified cronjobs.

    Scenario: roles::cron::github
    Given a node named "class-roles-cron-github"
    And a fact "github_user" of "barney"
    And a fact "github_pass" of "trouble"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Package[requests]"
    And there should be a resource "File[/usr/local/bin/github.py]"
    And there should be a resource "Cron::Crontab[github_gists_purge]"
      And the resource should have a "command" of "github.py -u barney -p trouble gist list -p 10 -e 25 | cut -f 2 -d ' ' | xargs -I {} github.py -u barney -p trouble gist del {} | logger -t github"
