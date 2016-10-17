Feature: apache/vhost/redirect.pp
  In order to manage apache vhost redirects on a system. This define must take an
  array of options to create valid virtualhost configs. It should set sane
  defaults if optional parameters aren't present.

    Scenario: apache::vhost::redirect default
    Given a node named "apache-redirect-default"
    When I compile the catalog
    Then compilation should succeed
    And there should be a file "/etc/apache2/sites-available/10-foo.bar.com"
      And the file should contain "Redirect permanent / http://baz.bar.com/"

    Scenario: apache::vhost::redirect temporary
    Given a node named "apache-redirect-temporary"
    When I compile the catalog
    Then compilation should succeed
    And there should be a file "/etc/apache2/sites-available/10-foo.bar.com"
      And the file should contain "Redirect temp / http://baz.bar.com/"

    Scenario: apache::vhost::redirect ssl enabled
    Given a node named "apache-redirect-ssl-enabled"
    When I compile the catalog
    Then compilation should succeed
    And there should be a file "/etc/apache2/sites-available/10-foo.bar.com"
      And the file should contain "SSLEngine On"
      And the file should contain "SSLCertificateFile /etc/ssl/certs/apache-ssl-cert.pem"
      And the file should contain "SSLCertificateKeyFile /etc/ssl/private/apache-ssl-key.key"
      And the file should contain "SSLCertificateChainFile /etc/ssl/certs/apache-ssl-chain.pem"

    Scenario: apache::vhost::redirect no params
    Given a node named "apache-redirect-no-params"
    When I try to compile the catalog
    Then compilation should fail
