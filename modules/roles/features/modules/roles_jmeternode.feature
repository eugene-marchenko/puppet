Feature: roles/jmeternode.pp
  In order to setup a jmeter node, this role must create the necessary
  resources to be able to run jmeter.

    Scenario: roles::jmeternode 
    Given a node named "class-roles-jmeternode"
    When I try to compile the catalog
    Then compilation should succeed
    And all resource dependencies should resolve
    And there should be a file "/usr/share/jmeter/lib/ext/StatAggVisualizer.jar"
    And there should be a file "/etc/jmeter/tests/dailybeast/DailyBeast-Load-Test.jmx"
    And there should be a file "/etc/jmeter/tests/dailybeast/DailyBeast-MemLeak-Test.jmx"
    And there should be a file "/etc/jmeter/tests/dailybeast/DailyBeast-Redirects-Test.jmx"
    And there should be a file "/etc/jmeter/tests/dailybeast/DailyBeast.jmx"
    And there should be a file "/etc/jmeter/tests/dailybeast/new-article_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/new-cheat-sheet_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/new-cheat_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/new-contributor_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/new-gallery_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/new-video_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/old-article_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/old-author_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/old-blog_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/old-blog_urls.txt.bak"
    And there should be a file "/etc/jmeter/tests/dailybeast/old-cheats_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/old-gallery_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/old-tag_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/old-video_urls.txt"
    And there should be a file "/etc/jmeter/tests/dailybeast/searches.txt"
    And there should be a file "/etc/jmeter/tests/education/articles.txt"
    And there should be a file "/etc/jmeter/tests/education/authors.txt"
    And there should be a file "/etc/jmeter/tests/education/blog_landing.txt"
    And there should be a file "/etc/jmeter/tests/education/blog_post.txt"
    And there should be a file "/etc/jmeter/tests/education/gutenbergids.csv"
    And there should be a file "/etc/jmeter/tests/education/gutenbergurls.txt"
    And there should be a file "/etc/jmeter/tests/education/landing_pages.txt"
    And there should be a file "/etc/jmeter/tests/education/request_just_articles_gb_vs_cq.jmx"
    And there should be a file "/etc/jmeter/tests/education/searches.txt"
    And there should be a file "/etc/jmeter/tests/education/tags.txt"
    And there should be a file "/etc/jmeter/tests/education/Test-Plan.jmx"
    And there should be a file "/etc/jmeter/tests/education/videos.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/articles.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/auth.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/Author.jmx"
    And there should be a file "/etc/jmeter/tests/newsweek/author_requests.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/authors.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/blog_landing.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/blog_post.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/careertree-test.jmx"
    And there should be a file "/etc/jmeter/tests/newsweek/echo_oscars_test.jmx"
    And there should be a file "/etc/jmeter/tests/newsweek/filter-list-us.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/Greenrankings-Factual-Test.jmx"
    And there should be a file "/etc/jmeter/tests/newsweek/Greenrankings-Factual-Test.zip"
    And there should be a file "/etc/jmeter/tests/newsweek/greenrankings-searchTerms.csv"
    And there should be a file "/etc/jmeter/tests/newsweek/greenrankings-thestreet.csv"
    And there should be a file "/etc/jmeter/tests/newsweek/gutenbergids.csv"
    And there should be a file "/etc/jmeter/tests/newsweek/gutenbergurls.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/hello_world.jmx"
    And there should be a file "/etc/jmeter/tests/newsweek/oscars_test.jmx"
    And there should be a file "/etc/jmeter/tests/newsweek/pagination-urls.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/request_just_articles_gb_vs_cq.jmx"
    And there should be a file "/etc/jmeter/tests/newsweek/searches.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/sort-ids-us.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/tags.txt"
    And there should be a file "/etc/jmeter/tests/newsweek/Test-Plan.jmx"
    And there should be a file "/etc/jmeter/tests/newsweek/videos.txt"
    And following directories should be created:
    | name                        |
    |/etc/jmeter                  |
    |/etc/jmeter/tests            |
    |/etc/jmeter/tests/dailybeast |
    |/etc/jmeter/tests/newsweek   |
    |/etc/jmeter/tests/education  |

