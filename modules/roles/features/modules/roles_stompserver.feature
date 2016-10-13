Feature: roles/stompserver.pp
  In order to setup a server with the services necessary to run stomp and other
  messaging protocols. This class must install the necessary packages, services,
  and configs to do so.

    Scenario: roles::stompserver 
    Given a node named "class-roles-stompserver"
    When I try to compile the catalog
    Then compilation should succeed
    And there should be a resource "Class[activemq]"
