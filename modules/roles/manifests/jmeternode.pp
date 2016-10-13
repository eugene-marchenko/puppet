# Class: roles::jmeternode
#
# This class installs jmeter resources
#
# == Parameters:
#
# == Required:
#
# None.
#
# == Optional:
#
# None.
#
# == Requires:
#
# stdlib
#
# == Sample Usage:
#
# include roles::jmeternode
#
# class { 'roles::jmeternode' : }
#
#
class roles::jmeternode() {

  include roles::base
  include java
  include jmeter
  
  $url = 'http://bootstrap.ec2.thedailybeast.com/public/jmeter'

  file { '/usr/share/jmeter/lib/ext/StatAggVisualizer.jar' :
    ensure  => 'present',
    path    => '/usr/share/jmeter/lib/ext/StatAggVisualizer.jar',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("${url}/lib/ext/StatAggVisualizer.jar")
  }

  file { '/etc/jmeter' :
    ensure  => 'directory',
    path    => '/etc/jmeter',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/etc/jmeter/tests' :
    ensure  => 'directory',
    path    => '/etc/jmeter/tests',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/etc/jmeter/tests/dailybeast' :
    ensure  => 'directory',
    path    => '/etc/jmeter/tests/dailybeast',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/etc/jmeter/tests/newsweek' :
    ensure  => 'directory',
    path    => '/etc/jmeter/tests/newsweek',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/etc/jmeter/tests/education' :
    ensure  => 'directory',
    path    => '/etc/jmeter/tests/education',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/etc/jmeter/tests/dailybeast/DailyBeast-Load-Test.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/DailyBeast-Load-Test.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/DailyBeast-Load-Test.jmx"),
  }

  file { '/etc/jmeter/tests/dailybeast/DailyBeast-MemLeak-Test.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/DailyBeast-MemLeak-Test.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/DailyBeast-MemLeak-Test.jmx"),
  }

  file { '/etc/jmeter/tests/dailybeast/DailyBeast-Redirects-Test.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/DailyBeast-Redirects-Test.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/DailyBeast-Redirects-Test.jmx"),
  }

  file { '/etc/jmeter/tests/dailybeast/DailyBeast.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/DailyBeast.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/DailyBeast.jmx"),
  }

  file { '/etc/jmeter/tests/dailybeast/new-article_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/new-article_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/new-article_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/new-cheat-sheet_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/new-cheat-sheet_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/new-cheat-sheet_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/new-cheat_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/new-cheat_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/new-cheat_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/new-contributor_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/new-contributor_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/new-contributor_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/new-gallery_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/new-gallery_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/new-gallery_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/new-video_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/new-video_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/new-video_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/old-article_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/old-article_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/old-article_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/old-author_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/old-author_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/old-author_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/old-blog_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/old-blog_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/old-blog_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/old-blog_urls.txt.bak' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/old-blog_urls.txt.bak',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/old-blog_urls.txt.bak"),
  }

  file { '/etc/jmeter/tests/dailybeast/old-cheats_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/old-cheats_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/old-cheats_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/old-gallery_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/old-gallery_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/old-gallery_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/old-tag_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/old-tag_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/old-tag_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/old-video_urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/old-video_urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/old-video_urls.txt"),
  }

  file { '/etc/jmeter/tests/dailybeast/searches.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/dailybeast/searches.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/dailybeast/searches.txt"),
  }

  file { '/etc/jmeter/tests/education/articles.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/articles.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/articles.txt"),
  }

  file { '/etc/jmeter/tests/education/authors.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/authors.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/authors.txt"),
  }

  file { '/etc/jmeter/tests/education/blog_landing.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/blog_landing.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/blog_landing.txt"),
  }

  file { '/etc/jmeter/tests/education/blog_post.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/blog_post.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/blog_post.txt"),
  }

  file { '/etc/jmeter/tests/education/gutenbergids.csv' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/gutenbergids.csv',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/gutenbergids.csv"),
  }

  file { '/etc/jmeter/tests/education/gutenbergurls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/gutenbergurls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/gutenbergurls.txt"),
  }

  file { '/etc/jmeter/tests/education/landing_pages.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/landing_pages.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/landing_pages.txt"),
  }

  file { '/etc/jmeter/tests/education/request_just_articles_gb_vs_cq.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/request_just_articles_gb_vs_cq.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/request_just_articles_gb_vs_cq.jmx"),
  }

  file { '/etc/jmeter/tests/education/searches.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/searches.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/searches.txt"),
  }

  file { '/etc/jmeter/tests/education/tags.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/tags.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/tags.txt"),
  }

  file { '/etc/jmeter/tests/education/Test-Plan.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/Test-Plan.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/Test-Plan.jmx"),
  }

  file { '/etc/jmeter/tests/education/videos.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/education/videos.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/education/videos.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/articles.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/articles.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/articles.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/auth.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/auth.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/auth.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/Author.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/Author.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/Author.jmx"),
  }

  file { '/etc/jmeter/tests/newsweek/author_requests.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/author_requests.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/author_requests.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/authors.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/authors.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/authors.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/blog_landing.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/blog_landing.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/blog_landing.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/blog_post.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/blog_post.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/blog_post.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/careertree-test.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/careertree-test.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/careertree-test.jmx"),
  }

  file { '/etc/jmeter/tests/newsweek/echo_oscars_test.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/echo_oscars_test.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/echo_oscars_test.jmx"),
  }

  file { '/etc/jmeter/tests/newsweek/filter-list-us.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/filter-list-us.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/filter-list-us.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/Greenrankings-Factual-Test.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/Greenrankings-Factual-Test.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/Greenrankings-Factual-Test.jmx"),
  }

  file { '/etc/jmeter/tests/newsweek/Greenrankings-Factual-Test.zip' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/Greenrankings-Factual-Test.zip',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/Greenrankings-Factual-Test.zip"),
  }

  file { '/etc/jmeter/tests/newsweek/greenrankings-searchTerms.csv' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/greenrankings-searchTerms.csv',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/greenrankings-searchTerms.csv"),
  }

  file { '/etc/jmeter/tests/newsweek/greenrankings-thestreet.csv' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/greenrankings-thestreet.csv',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/greenrankings-thestreet.csv"),
  }

  file { '/etc/jmeter/tests/newsweek/gutenbergids.csv' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/gutenbergids.csv',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/gutenbergids.csv"),
  }

  file { '/etc/jmeter/tests/newsweek/gutenbergurls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/gutenbergurls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/gutenbergurls.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/hello_world.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/hello_world.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/hello_world.jmx"),
  }

  file { '/etc/jmeter/tests/newsweek/oscars_test.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/oscars_test.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/oscars_test.jmx"),
  }

  file { '/etc/jmeter/tests/newsweek/pagination-urls.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/pagination-urls.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/pagination-urls.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/request_just_articles_gb_vs_cq.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/request_just_articles_gb_vs_cq.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/request_just_articles_gb_vs_cq.jmx"),
  }

  file { '/etc/jmeter/tests/newsweek/searches.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/searches.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/searches.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/sort-ids-us.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/sort-ids-us.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/sort-ids-us.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/tags.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/tags.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/tags.txt"),
  }

  file { '/etc/jmeter/tests/newsweek/Test-Plan.jmx' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/Test-Plan.jmx',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/Test-Plan.jmx"),
  }

  file { '/etc/jmeter/tests/newsweek/videos.txt' :
    ensure  => 'present',
    path    => '/etc/jmeter/tests/newsweek/videos.txt',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => curl("$url/tests/newsweek/videos.txt"),
  }
  Class[roles::base]
  ->  Class[java]
  ->  Class[jmeter]
  ->  File['/usr/share/jmeter/lib/ext/StatAggVisualizer.jar']
  ->  File['/etc/jmeter']
  ->  File['/etc/jmeter/tests']
  ->  File['/etc/jmeter/tests/dailybeast']
  ->  File['/etc/jmeter/tests/newsweek']
  ->  File['/etc/jmeter/tests/education']
  ->  File['/etc/jmeter/tests/dailybeast/DailyBeast-Load-Test.jmx']
  ->  File['/etc/jmeter/tests/dailybeast/DailyBeast-MemLeak-Test.jmx']
  ->  File['/etc/jmeter/tests/dailybeast/DailyBeast-Redirects-Test.jmx']
  ->  File['/etc/jmeter/tests/dailybeast/DailyBeast.jmx']
  ->  File['/etc/jmeter/tests/dailybeast/new-article_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/new-cheat-sheet_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/new-cheat_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/new-contributor_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/new-gallery_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/new-video_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/old-article_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/old-author_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/old-blog_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/old-blog_urls.txt.bak']
  ->  File['/etc/jmeter/tests/dailybeast/old-cheats_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/old-gallery_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/old-tag_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/old-video_urls.txt']
  ->  File['/etc/jmeter/tests/dailybeast/searches.txt']
  ->  File['/etc/jmeter/tests/education/articles.txt']
  ->  File['/etc/jmeter/tests/education/authors.txt']
  ->  File['/etc/jmeter/tests/education/blog_landing.txt']
  ->  File['/etc/jmeter/tests/education/blog_post.txt']
  ->  File['/etc/jmeter/tests/education/gutenbergids.csv']
  ->  File['/etc/jmeter/tests/education/gutenbergurls.txt']
  ->  File['/etc/jmeter/tests/education/landing_pages.txt']
  ->  File['/etc/jmeter/tests/education/request_just_articles_gb_vs_cq.jmx']
  ->  File['/etc/jmeter/tests/education/searches.txt']
  ->  File['/etc/jmeter/tests/education/tags.txt']
  ->  File['/etc/jmeter/tests/education/Test-Plan.jmx']
  ->  File['/etc/jmeter/tests/education/videos.txt']
  ->  File['/etc/jmeter/tests/newsweek/articles.txt']
  ->  File['/etc/jmeter/tests/newsweek/auth.txt']
  ->  File['/etc/jmeter/tests/newsweek/Author.jmx']
  ->  File['/etc/jmeter/tests/newsweek/author_requests.txt']
  ->  File['/etc/jmeter/tests/newsweek/authors.txt']
  ->  File['/etc/jmeter/tests/newsweek/blog_landing.txt']
  ->  File['/etc/jmeter/tests/newsweek/blog_post.txt']
  ->  File['/etc/jmeter/tests/newsweek/careertree-test.jmx']
  ->  File['/etc/jmeter/tests/newsweek/echo_oscars_test.jmx']
  ->  File['/etc/jmeter/tests/newsweek/filter-list-us.txt']
  ->  File['/etc/jmeter/tests/newsweek/Greenrankings-Factual-Test.jmx']
  ->  File['/etc/jmeter/tests/newsweek/Greenrankings-Factual-Test.zip']
  ->  File['/etc/jmeter/tests/newsweek/greenrankings-searchTerms.csv']
  ->  File['/etc/jmeter/tests/newsweek/greenrankings-thestreet.csv']
  ->  File['/etc/jmeter/tests/newsweek/gutenbergids.csv']
  ->  File['/etc/jmeter/tests/newsweek/gutenbergurls.txt']
  ->  File['/etc/jmeter/tests/newsweek/hello_world.jmx']
  ->  File['/etc/jmeter/tests/newsweek/oscars_test.jmx']
  ->  File['/etc/jmeter/tests/newsweek/pagination-urls.txt']
  ->  File['/etc/jmeter/tests/newsweek/request_just_articles_gb_vs_cq.jmx']
  ->  File['/etc/jmeter/tests/newsweek/searches.txt']
  ->  File['/etc/jmeter/tests/newsweek/sort-ids-us.txt']
  ->  File['/etc/jmeter/tests/newsweek/tags.txt']
  ->  File['/etc/jmeter/tests/newsweek/Test-Plan.jmx']
  ->  File['/etc/jmeter/tests/newsweek/videos.txt']
}
