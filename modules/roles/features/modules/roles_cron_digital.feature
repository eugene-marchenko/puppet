Feature: roles/cron/digital.pp
  In order to run the digital cronjobs for various tasks. This package must
  install the necessary resources to run the specified cronjobs.

    Scenario: roles::cron::digital
    Given a node named "class-roles-cron-digital"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Package[oauth2]"
    And there should be a resource "Package[tweepy]"
    And there should be a resource "Package[cartodb]"
