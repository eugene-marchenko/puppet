Feature: roles/jenkins.pp
  In order to setup a server for running continuous integration tests, this
  class must install the necessary resources for running such a server such as
  necessary python packages, java, and mounting of a snapshot.

    Scenario: roles::jenkins
    Given a node named "class-roles-jenkins"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Exec[jenkins(mkdir -p /var/lib/jenkins)]"
    And there should be a resource "Exec[jenkins(mkdir -p /var/lib/jenkins/backups)]"
    And there should be a resource "Exec[jenkins(get_s3_file_script)]"
    And there should be a resource "Exec[jenkins(get_s3_file)]"
    And there should be a resource "Exec[jenkins(expand_backup_directory)]"
    And there should be a resource "Exec[jenkins(chown_backup_directory)]"
    And there should be a resource "Exec[jenkins(get_jenkins_restore_script)]"
    And there should be a resource "Exec[jenkins(unpack_jenkins_restore_script)]"
    And there should be a resource "Exec[jenkins(restore_jenkins_backup)]"
    And there should be a resource "Exec[jenkins(restart_jenkins)]"
    And a fact "github_user" of "nwdb-dev"
    And a fact "github_pass" of "d@ilyb3ast"
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
      And the file should have a "target" of "/var/lib/jenkins"

    Scenario: roles::jenkins from facts
    Given a node named "class-roles-jenkins"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
