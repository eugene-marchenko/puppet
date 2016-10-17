Feature: jetty/config.pp
  In order to jettyor services on a system. This define must take a hash of
  configs to install and create them.

    Scenario: jetty::config default
    Given a node named "jetty-config-default"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/default/jetty" should be "present"
      And the file should contain "NO_START=0"
      And the file should contain "VERBOSE=yes"
      And the file should contain "#JETTY_USER=jetty"
      And the file should contain "#JETTY_HOST=$(uname -n)"
      And the file should contain "#JETTY_PORT=8080"
      And the file should contain "#JETTY_SHUTDOWN=30"
      And the file should contain "#JETTY_ARGS="
      And the file should contain /^#JAVA_OPTIONS="-Xmx256m -Djava.awt.headless=true"/
      And the file should contain "#JAVA_HOME="
      And the file should contain /^#JDK_DIRS="/usr/lib/jvm/default-java /usr/lib/jvm/java-6-sun"/
      And the file should contain "#JSP_COMPILER=jikes"
      And the file should contain "#JETTY_TMP=/var/cache/jetty"
      And the file should contain "#JETTY_START_CONFIG=/etc/jetty/start.config"
      And the file should contain "#LOGFILE_DAYS=14"
    And there should be a script "/etc/init.d/jetty"

    Scenario: jetty::config from facts
    Given a node named "jetty-config-default"
    And a fact "jetty_enabled" of "false"
    And a fact "jetty_verbose" of "false"
    And a fact "jetty_user" of "www-data"
    And a fact "jetty_listen_address" of "localhost"
    And a fact "jetty_listen_port" of "8443"
    And a fact "jetty_shutdown_timeout" of "60"
    And a fact "jetty_args" of "etc/jetty-logging.xml"
    And a fact "jetty_java_options" of "-Xmx256m -Djava.awt.headless=true"
    And a fact "jetty_java_home" of "/opt/java"
    And a fact "jetty_jdk_dirs" of "/opt/java"
    And a fact "jetty_jsp_compiler" of "gcj"
    And a fact "jetty_tmp" of "/tmp/jetty"
    And a fact "jetty_start_config" of "/etc/jetty/config"
    And a fact "jetty_logfile_keep_days" of "7"
    When I compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And file "/etc/default/jetty" should be "present"
      And the file should contain "NO_START=1"
      And the file should contain "VERBOSE=no"
      And the file should contain "JETTY_USER=www-data"
      And the file should contain "JETTY_HOST=localhost"
      And the file should contain "JETTY_PORT=8443"
      And the file should contain "JETTY_SHUTDOWN=60"
      And the file should contain /^JETTY_ARGS="etc/jetty-logging.xml"/
      And the file should contain /^JAVA_OPTIONS="-Xmx256m -Djava.awt.headless=true"/
      And the file should contain "JAVA_HOME=/opt/java"
      And the file should contain /^JDK_DIRS="/opt/java"/
      And the file should contain "JSP_COMPILER=gcj"
      And the file should contain "JETTY_TMP=/tmp/jetty"
      And the file should contain "JETTY_START_CONFIG=/etc/jetty/config"
      And the file should contain "LOGFILE_DAYS=7"
    And there should be a script "/etc/init.d/jetty"

    Scenario: jetty::config no parameters
    Given a node named "jetty-config-no-params"
    When I try to compile the catalog
    Then compilation should fail
