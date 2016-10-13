Feature: roles/buildserver.pp
  In order to setup a server for running continuous integration tests, this
  class must install the necessary resources for running such a server such as
  necessary python packages, java, and mounting of a snapshot.

    Scenario: roles::buildserver
    Given a node named "class-roles-buildserver"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Exec[buildserver(mkdir -p /opt)]"
    And there should be a resource "Mount[/opt]"
      And the resource should have an "ensure" of "mounted"
      And the resource should have a "device" of "/dev/mapper/elastic--vol-data01"
      And the resource should have an "fstype" of "xfs"
      And the resource should have an "options" of "defaults"
    And following packages should be dealt with:
      | name          | state   |
      | boto          | 2.6.0   |
      | libc6-i386    | latest  |
      | libxml2-dev   | latest  |
      | libxslt1-dev  | latest  |
      | BeautifulSoup | latest  |
      | jinja2        | latest  |
      | lxml          | latest  |
      | mechanize     | latest  |
      | simplejson    | latest  |
      | pysolr        | latest  |
      | pycurl        | latest  |
      | pyyaml        | latest  |
      | nose          | latest  |
      | html2text     | latest  |
      | jenkinsapi    | latest  |
      | jprops        | latest  |
    And there should be a resource "Class[java]"
    And file "/root/.jenkins" should be "link"
      And the file should have a "target" of "/opt/jenkins"

    Scenario: roles::buildserver from facts
    Given a node named "class-roles-buildserver"
    And a fact "build_mount_path" of "/d0/data"
    And a fact "build_mount_device" of "/dev/sdm"
    And a fact "build_mount_fstype" of "ext3"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Exec[buildserver(mkdir -p /d0/data)]"
    And there should be a resource "Mount[/d0/data]"
      And the resource should have an "ensure" of "mounted"
      And the resource should have a "device" of "/dev/sdm"
      And the resource should have an "fstype" of "ext3"
      And the resource should have an "options" of "defaults"
