Feature: roles/dispatcher.pp
  In order to setup an apache dispatcher server, this role must create the
  necessary vhosts and supporting files.

    Scenario: roles::dispatcher
    Given a node named "class-roles-dispatcher"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[apache]"
    And there should be a resource "Apache::Vhost[default]"
      And the resource should have "enable" set to "false"
    And there should be a resource "Class[apache::dispatcher]"
    And there should be a resource "Apache::Dispatcher::Vhost[www.thedailybeast.com]"
    And there should be a resource "Apache::Dispatcher::Vhost[www.newsweek.com]"
    And file "/_etc_apache2_dispatcher.any/fragments/0__etc_apache2_dispatcher.any_head" should be "present"
    And file "/_etc_apache2_dispatcher.any/fragments/10__etc_apache2_dispatcher.any_www.thedailybeast.com" should be "present"
      And the file should contain /    \/rend0 \{ \/hostname "www-prod-app1.ec2.newsweek.com" \/port "80" \/timeout "30000" \}/
      And the file should contain /    \/rend1 \{ \/hostname "www-prod-app2.ec2.newsweek.com" \/port "80" \/timeout "30000" \}/
    And file "/_etc_apache2_dispatcher.any/fragments/20__etc_apache2_dispatcher.any_www.newsweek.com" should be "present"
      And the file should contain /    \/rend0 \{ \/hostname "www-prod-app1.ec2.newsweek.com" \/port "80" \/timeout "30000" \}/
      And the file should contain /    \/rend1 \{ \/hostname "www-prod-app2.ec2.newsweek.com" \/port "80" \/timeout "30000" \}/
    And file "/_etc_apache2_dispatcher.any/fragments/99__etc_apache2_dispatcher.any_tail" should be "present"
    And there should be a file "/etc/apache2/apache2.conf"
    And there should be a file "/etc/apache2/conf.d/security"
    And file "/etc/apache2/dispatcher.any" should be "present"
    And there should be a file "/etc/apache2/envvars"
    And there should be a file "/etc/apache2/mods-available/dispatcher.conf"
    And there should be a file "/etc/apache2/mods-available/dispatcher.load"
    And there should be a file "/etc/apache2/sites-available/10-www.thedailybeast.com"
    And there should be a file "/etc/apache2/sites-available/20-www.newsweek.com"
    And there should be a file "/etc/apache2/www.newsweek.com/blog-redirects.txt"
    And there should be a file "/etc/apache2/www.newsweek.com/gutenberg-redirects.txt"
    And there should be a file "/etc/apache2/www.newsweek.com/mobile-redirects.txt"
    And there should be a file "/etc/apache2/www.newsweek.com/old-host-redirects.txt"
    And there should be a file "/etc/apache2/www.newsweek.com/photo-redirects.txt"
    And there should be a file "/etc/apache2/www.newsweek.com/vanity-redirects.txt"
    And there should be a file "/etc/apache2/www.thedailybeast.com/404-pages.txt"
    And there should be a file "/etc/apache2/www.thedailybeast.com/article-to-gallery-redirects.txt"
    And there should be a file "/etc/apache2/www.thedailybeast.com/blog-redirects.txt"
    And there should be a file "/etc/apache2/www.thedailybeast.com/cheat-sheet-redirects.txt"
    And there should be a file "/etc/apache2/www.thedailybeast.com/gallery-redirects.txt"
    And there should be a file "/etc/apache2/www.thedailybeast.com/old-host-redirects.txt"
    And there should be a file "/etc/apache2/www.thedailybeast.com/vanity-url-redirects.txt"
    And there should be a file "/etc/apache2/www.thedailybeast.com/video-redirects.txt"
    And there should be a file "/etc/default/apache2"
    And there should be a file "/etc/logrotate.d/apache2"
    And there should be a file "/usr/lib/apache2/modules/mod_dispatcher.so"
    And there should be a file "/var/www/errors/404.html"
    And there should be a file "/var/www/ping.txt"
    And there should be a file "/etc/cron.d/remove_dispatcher_cruft_www_thedailybeast_com"
      And the file should contain "find /mnt/dispatcher/www.thedailybeast.com/ -ignore_readdir_race -type f -ctime +30 -print0 | xargs -0 rm -f"
    And there should be a file "/etc/cron.d/remove_dispatcher_cruft_www_newsweek_com"
      And the file should contain "find /mnt/dispatcher/www.newsweek.com/ -ignore_readdir_race -type f -ctime +30 -print0 | xargs -0 rm -f"
    And there should be a resource "File[/mnt/dispatcher/www.thedailybeast.com]"
      And the state should be "directory"
    And there should be a resource "File[/mnt/dispatcher/www.newsweek.com]"
      And the state should be "directory"
    And there should be a resource "File[/var/log/apache2]"
      And the state should be "directory"
    And following directories should be created:
      | name                                  |
      | /etc/apache2/www.thedailybeast.com    |
      | /etc/apache2/www.newsweek.com         |
      | /mnt/dispatcher                       |
      | /var/www/errors                       |

    Scenario: roles::dispatcher different vhosts from facts
    Given a node named "class-roles-dispatcher"
    And a fact "dailybeast_vhost" of "uat.thedailybeast.com"
    And a fact "newsweek_vhost" of "uat.ec2.newsweek.com"
    And a fact "dailybeast_renders" of "uat-app-1635820099.us-east-1.elb.amazonaws.com:8080"
    And a fact "newsweek_renders" of "publish01-uat.ec2.newsweek.com:8080"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a resource "Class[apache]"
    And there should be a resource "Apache::Vhost[default]"
      And the resource should have "enable" set to "false"
    And there should be a resource "Class[apache::dispatcher]"
    And there should be a resource "Apache::Dispatcher::Vhost[uat.thedailybeast.com]"
    And there should be a resource "Apache::Dispatcher::Vhost[uat.ec2.newsweek.com]"
    And file "/_etc_apache2_dispatcher.any/fragments/0__etc_apache2_dispatcher.any_head" should be "present"
    And file "/_etc_apache2_dispatcher.any/fragments/10__etc_apache2_dispatcher.any_uat.thedailybeast.com" should be "present"
      And the file should contain /    \/rend0 \{ \/hostname "uat-app-1635820099.us-east-1.elb.amazonaws.com" \/port "8080" \/timeout "30000" \}/
    And file "/_etc_apache2_dispatcher.any/fragments/20__etc_apache2_dispatcher.any_uat.ec2.newsweek.com" should be "present"
      And the file should contain /    \/rend0 \{ \/hostname "publish01-uat.ec2.newsweek.com" \/port "8080" \/timeout "30000" \}/
    And file "/_etc_apache2_dispatcher.any/fragments/99__etc_apache2_dispatcher.any_tail" should be "present"
    And there should be a file "/etc/apache2/apache2.conf"
    And there should be a file "/etc/apache2/conf.d/security"
    And file "/etc/apache2/dispatcher.any" should be "present"
    And there should be a file "/etc/apache2/envvars"
    And there should be a file "/etc/apache2/mods-available/dispatcher.conf"
    And there should be a file "/etc/apache2/mods-available/dispatcher.load"
    And there should be a file "/etc/apache2/sites-available/10-uat.thedailybeast.com"
    And there should be a file "/etc/apache2/sites-available/20-uat.ec2.newsweek.com"
    And there should be a file "/etc/apache2/uat.ec2.newsweek.com/blog-redirects.txt"
    And there should be a file "/etc/apache2/uat.ec2.newsweek.com/gutenberg-redirects.txt"
    And there should be a file "/etc/apache2/uat.ec2.newsweek.com/mobile-redirects.txt"
    And there should be a file "/etc/apache2/uat.ec2.newsweek.com/old-host-redirects.txt"
    And there should be a file "/etc/apache2/uat.ec2.newsweek.com/photo-redirects.txt"
    And there should be a file "/etc/apache2/uat.ec2.newsweek.com/vanity-redirects.txt"
    And there should be a file "/etc/apache2/uat.thedailybeast.com/404-pages.txt"
    And there should be a file "/etc/apache2/uat.thedailybeast.com/article-to-gallery-redirects.txt"
    And there should be a file "/etc/apache2/uat.thedailybeast.com/blog-redirects.txt"
    And there should be a file "/etc/apache2/uat.thedailybeast.com/cheat-sheet-redirects.txt"
    And there should be a file "/etc/apache2/uat.thedailybeast.com/gallery-redirects.txt"
    And there should be a file "/etc/apache2/uat.thedailybeast.com/old-host-redirects.txt"
    And there should be a file "/etc/apache2/uat.thedailybeast.com/vanity-url-redirects.txt"
    And there should be a file "/etc/apache2/uat.thedailybeast.com/video-redirects.txt"
    And there should be a file "/etc/default/apache2"
    And there should be a file "/etc/logrotate.d/apache2"
    And there should be a file "/usr/lib/apache2/modules/mod_dispatcher.so"
    And there should be a file "/var/www/errors/404.html"
    And there should be a file "/var/www/ping.txt"
    And there should be a file "/etc/cron.d/remove_dispatcher_cruft_uat_thedailybeast_com"
      And the file should contain "find /mnt/dispatcher/uat.thedailybeast.com/ -ignore_readdir_race -type f -ctime +30 -print0 | xargs -0 rm -f"
    And there should be a file "/etc/cron.d/remove_dispatcher_cruft_uat_ec2_newsweek_com"
      And the file should contain "find /mnt/dispatcher/uat.ec2.newsweek.com/ -ignore_readdir_race -type f -ctime +30 -print0 | xargs -0 rm -f"
    And there should be a resource "File[/mnt/dispatcher/uat.thedailybeast.com]"
      And the state should be "directory"
    And there should be a resource "File[/mnt/dispatcher/uat.ec2.newsweek.com]"
      And the state should be "directory"
    And there should be a resource "File[/var/log/apache2]"
      And the state should be "directory"
    And following directories should be created:
      | name                                  |
      | /etc/apache2/uat.thedailybeast.com    |
      | /etc/apache2/uat.ec2.newsweek.com     |
      | /mnt/dispatcher                       |
      | /var/www/errors                       |

