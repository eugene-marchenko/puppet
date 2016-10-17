Feature: apache/dispatcher/vhost/file.pp
  In order to manage files required by apache dispatcher vhosts on a system.
  This define must take a list of parameters and create the necessary files
  It should set sane defaults for all optional parameters.

  Scenario: apache dispatcher vhost file template
  Given a node named "apache-dispatcher-vhost-file-template"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/apache2/www.example.com/foo.txt" should be "present"
    And the file should contain "DispatcherConfig"

  Scenario: apache dispatcher vhost file content
  Given a node named "apache-dispatcher-vhost-file-content"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/apache2/www.example.com/foo.txt" should be "present"
    And the file should contain "foo"

  Scenario: apache dispatcher vhost file source 
  Given a node named "apache-dispatcher-vhost-file-source"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/apache2/www.example.com/foo.txt" should be "present"
    And the file should have a "source" of "puppet:///modules/apache/some/file.txt"

  Scenario: apache dispatcher vhost file different path
  Given a node named "apache-dispatcher-vhost-file-diff-path"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/tmp/foo.txt" should be "present"
    And the file should contain "foo"

  Scenario: apache dispatcher vhost file invalid
  Given a node named "apache-dispatcher-vhost-file-invalid"
  When I try to compile the catalog
  Then compilation should fail

  Scenario: apache dispatcher vhost file removed
  Given a node named "apache-dispatcher-vhost-file-removed"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/etc/apache2/www.example.com/foo.txt" should be "absent"
