# Class: roles::dispatcher
#
# This class installs apache dispatcher resources
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
# include roles::dispatcher
#
# class { 'roles::dispatcher' : }
#
#
class roles::dispatcher() {

  include roles::base

  # Install base modules
  include newrelic
  include apache
  include apache::vhost::default
  include apache::dispatcher

  # Get optional facts
  if $::dailybeast_vhost {
    $dailybeast_vhost = $::dailybeast_vhost
  } else {
    $dailybeast_vhost = 'www.thedailybeast.com'
  }

  # Regsub to underscores
  $_dailybeast_vhost = regsubst($dailybeast_vhost, '\.', '_', 'G')

  if $::dailybeast_renders {
    $dailybeast_renders = $::dailybeast_renders
  } else {
    $dailybeast_renders = [ 'www-prod-app1.ec2.thedailybeast.com:80',
                            'www-prod-app2.ec2.thedailybeast.com:80', ]
  }

  # The default vhost is enabled by default, disable this.
  Apache::Vhost <| title == 'default' |> {
      enable => false,
  }

  # The Daily Beast Vhost
  apache::dispatcher::vhost { $dailybeast_vhost :
    port            => '80',
    docroot         => "/mnt/dispatcher/${dailybeast_vhost}",
    priority        => '10',
    default_vhost   => true,
    vhost_template  => 'data/dispatcher/dailybeast/dailybeast.conf.erb',
    renders         => $dailybeast_renders,
    d_tmpl_priority => '10',
    serveraliases   => [ 'dailybeast.com',
                        '*.thedailybeast.com',
                        '*.dailybeast.com',
                      ],
  }

  apache::dispatcher::vhost::file { '404-pages.txt' :
    servername => $dailybeast_vhost,
    template   => 'data/dispatcher/dailybeast/404-pages.txt.erb',
  }

  apache::dispatcher::vhost::file { 'article-to-gallery-redirects.txt' :
    servername => $dailybeast_vhost,
    template   => 'data/dispatcher/dailybeast/article-to-gallery-redirects.txt.erb',
  }

  apache::dispatcher::vhost::file { 'blog-redirects.txt' :
    servername => $dailybeast_vhost,
    template   => 'data/dispatcher/dailybeast/blog-redirects.txt.erb',
  }

  apache::dispatcher::vhost::file { 'cheat-sheet-redirects.txt' :
    servername => $dailybeast_vhost,
    template   => 'data/dispatcher/dailybeast/cheat-sheet-redirects.txt.erb',
  }

  apache::dispatcher::vhost::file { 'gallery-redirects.txt' :
    servername => $dailybeast_vhost,
    template   => 'data/dispatcher/dailybeast/gallery-redirects.txt.erb',
  }

  apache::dispatcher::vhost::file { 'old-host-redirects.txt' :
    servername => $dailybeast_vhost,
    template   => 'data/dispatcher/dailybeast/old-host-redirects.txt.erb',
  }

  apache::dispatcher::vhost::file { 'vanity-url-redirects.txt' :
    servername => $dailybeast_vhost,
    template   => 'data/dispatcher/dailybeast/vanity-url-redirects.txt.erb',
  }

  apache::dispatcher::vhost::file { 'video-redirects.txt' :
    servername => $dailybeast_vhost,
    template   => 'data/dispatcher/dailybeast/video-redirects.txt.erb',
  }

#  file { '/usr/local/bin/statfilerefresh.sh':
#    owner      => root,
#    mode       => '0755',
#    ensure     => 'present',
#    source     => 'puppet:///modules/apache/scripts/statfilerefresh.sh'
#  }

#  cron::crontab { "remove_dispatcher_cruft_${_dailybeast_vhost}" :
#    command     => "find -O2 /mnt/dispatcher/${dailybeast_vhost}/ -ignore_readdir_race -type f -ctime +30 ! -name '.stat' -delete",
#    minute      => '0',
#    hour        => '01',
#    comment     => "Remove old dispatcher files for ${dailybeast_vhost}",
#  }

#  cron::crontab { "statfilerefresh_articles_${_dailybeast_vhost}" :
#    command   => "find -O2 /mnt/dispatcher/${dailybeast_vhost}/articles -maxdepth 4 -name '.stat' -type f -not -newer /mnt/dispatcher/${dailybeast_vhost}/.stat -exec /usr/bin/touch -d '15 minutes ago' {} +",
#    comment   => "update ctime of statfiles of all articles when homepage is updated",
#    minute    => "*/20",
#    hour      => "*",
#  }

#  cron::crontab { "statfilerefresh_cheats_${_dailybeast_vhost}" :
#    command   => "/usr/local/bin/statfilerefresh.sh ${dailybeast_vhost}",
#    comment   => "update ctime of statfiles of all cheat-sheets when cheats are updated",
#    minute    => "*/17",
#    hour      => "*",
#  }

  # only do the following for prod envs
  if ( $::env == prod and $hostname =~ /^dispatch(\d+)/ ) {

    file { '/usr/local/bin/parsely_cache_clear.py':
      owner      => root,
      mode       => '0755',
      ensure     => 'present',
      source     => 'puppet:///modules/apache/scripts/parsely_cache_clear.py'
    }

    cron::crontab { "parsely_hourly_refresh" :
      command   => "/usr/local/bin/parsely_cache_clear.py",
      comment   => "fetch some things from parsely",
      minute    => fqdn_rand( 60 ),
      hour      => "*",
      user      => 'www-data',
    }

    Class[apache] -> Cron::Crontab["parsely_hourly_refresh"]

  } else {

    file { '/usr/local/bin/parsely_cache_clear.py':
      owner      => root,
      mode       => '0755',
      ensure     => 'absent',
      source     => 'puppet:///modules/apache/scripts/parsely_cache_clear.py'
    }

    # commented out since puppet 2.7's cron resource doesn't support ensure
    #cron::crontab { "parsely_hourly_refresh" :
    #  command   => "/usr/local/bin/parsely_cache_clear.py",
    #  comment   => "fetch some things from parsely",
    #  minute    => fqdn_rand( 60 ),
    #  hour      => "*",
    #  ensure     => 'absent',
    #}

  }
  Class[apache] -> File['/usr/local/bin/parsely_cache_clear.py']
 
  # Anchor apache
  Class[roles::base] -> Class[apache]

  # Ensure Apache runs before everything else
  Class[apache] -> Apache::Vhost['default']
  Class[apache] -> Class[apache::dispatcher]
  Class[apache] -> Apache::Dispatcher::Vhost[$dailybeast_vhost]
#  Class[apache] -> File['/usr/local/bin/statfilerefresh.sh']
#  Class[apache] -> Cron::Crontab["remove_dispatcher_cruft_${_dailybeast_vhost}"]
#  Class[apache] -> Cron::Crontab["statfilerefresh_articles_${_dailybeast_vhost}"]
#  Class[apache] -> Cron::Crontab["statfilerefresh_cheats_${_dailybeast_vhost}"]

  # Ensure proxy_http apache modules is enabled
  exec { "a2enmod_proxy_http":
    command => "/usr/sbin/a2enmod proxy_http",
    creates => "/etc/apache2/mods-enabled/proxy_http.load",
    require => Class[apache]
  }

  # allow jenkins to clear cache
  if ( $::env != prod ) {
    sudo::config::sudoer { 'jenkins-dispatchflush':
      content => 'jenkins ALL=(ALL) NOPASSWD: /bin/rm -rf /mnt/dispatcher/*/*'
    }
  }

  # Ensure dailybeast vhost is installed before vhost files
  Apache::Dispatcher::Vhost[$dailybeast_vhost] -> Apache::Dispatcher::Vhost::File['404-pages.txt']
  Apache::Dispatcher::Vhost[$dailybeast_vhost] -> Apache::Dispatcher::Vhost::File['article-to-gallery-redirects.txt']
  Apache::Dispatcher::Vhost[$dailybeast_vhost] -> Apache::Dispatcher::Vhost::File['blog-redirects.txt']
  Apache::Dispatcher::Vhost[$dailybeast_vhost] -> Apache::Dispatcher::Vhost::File['cheat-sheet-redirects.txt']
  Apache::Dispatcher::Vhost[$dailybeast_vhost] -> Apache::Dispatcher::Vhost::File['gallery-redirects.txt']
  Apache::Dispatcher::Vhost[$dailybeast_vhost] -> Apache::Dispatcher::Vhost::File['old-host-redirects.txt']
  Apache::Dispatcher::Vhost[$dailybeast_vhost] -> Apache::Dispatcher::Vhost::File['vanity-url-redirects.txt']
  Apache::Dispatcher::Vhost[$dailybeast_vhost] -> Apache::Dispatcher::Vhost::File['video-redirects.txt']

  # Dailybeast vhost files notify apache service
  Apache::Dispatcher::Vhost::File['404-pages.txt']                    ~> Class[apache::service]
  Apache::Dispatcher::Vhost::File['article-to-gallery-redirects.txt'] ~> Class[apache::service]
  Apache::Dispatcher::Vhost::File['blog-redirects.txt']               ~> Class[apache::service]
  Apache::Dispatcher::Vhost::File['cheat-sheet-redirects.txt']        ~> Class[apache::service]
  Apache::Dispatcher::Vhost::File['gallery-redirects.txt']            ~> Class[apache::service]
  Apache::Dispatcher::Vhost::File['old-host-redirects.txt']           ~> Class[apache::service]
  Apache::Dispatcher::Vhost::File['vanity-url-redirects.txt']         ~> Class[apache::service]
  Apache::Dispatcher::Vhost::File['video-redirects.txt']              ~> Class[apache::service]

}
