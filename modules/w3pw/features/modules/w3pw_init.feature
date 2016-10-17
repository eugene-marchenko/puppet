Feature: w3pw/init.pp
  In order to manage w3pw on a system. The w3pw class should by default
  install the w3pw package, config files, and ensure sure necessary services
  are running. It should provide an ability to remove itself as well.

  Scenario: w3pw default
  Given a node named "class-w3pw-default"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And file "/usr/share/w3pw/lib/config.php" should be "present"
  And following packages should be dealt with:
    | name  | state   |
    | w3pw  | latest  |

  Scenario: w3pw removed
  Given a node named "class-w3pw-uninstalled"
  When I compile the catalog
  Then compilation should succeed
  And all resource dependencies should resolve
  And following packages should be dealt with:
  | name  | state   |
  | w3pw  | purged  |
  And there should be no resource "File[/usr/share/w3pw/lib/config.php]"
