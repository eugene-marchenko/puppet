# Class: roles::rootdomain
#
# This meta class installs cron resources
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
# include roles::rootdomain
#
# class { 'roles::rootdomain' : }
#
#
class roles::rootdomain() {

  include roles::base
  include apache

  apache::vhost::redirect { 'newsweekdailybeast.com' :
    port  => '80',
    dest  => 'http://www.thedailybeast.com',
  }

  apache::vhost::redirect { 'dailybeast.com' :
    port  => '80',
    dest  => 'http://www.thedailybeast.com',
  }

  apache::vhost::redirect { 'havingtroublevoting.com' :
    port  => '80',
    dest  => 'http://www.havingtroublevoting.com',
  }

  apache::vhost::redirect { 'thisisyourreponguns.com' :
    port          => '80',
    dest          => 'http://thedailybeast.thisisyourreponguns.com',
    serveraliases => [ '*.thisisyourreponguns.com' ],
  }

  apache::vhost::redirect { 'author.ec2.thedailybeast.com_80' :
    port        => '80',
    servername  => 'author.ec2.thedailybeast.com',
    dest        => 'https://author.ec2.thedailybeast.com',
  }
 
  apache::vhost::redirect { 'author.ec2.thedailybeast.com_443' :
    port        => '443',
    servername  => 'author.ec2.thedailybeast.com',
    dest        => 'https://author.ec2.thedailybeast.com',
    ssl         => true,
    ssl_cert    => $apache::params::apache_ssl_cert,
  }

  apache::vhost::redirect { 'author.thedailybeast.com_80' :
    port        => '80',
    servername  => 'author.thedailybeast.com',
    dest        => 'https://author.ec2.thedailybeast.com',
  }

  apache::vhost::redirect { 'womenintheworld.org' :
    port  => '80',
    dest  => 'http://www.thedailybeast.com/witw.html',
    serveraliases => [ '*.womenintheworld.org' ],
  }

  apache::vhost::redirect { 'games.thedailybeast.com' :
    port  => '80',
    dest  => 'http://www.thedailybeast.com',
  }

  motd::register { 'RootDomain': }

  Class[roles::base]
  -> Apache::Vhost::Redirect['newsweekdailybeast.com']
  -> Apache::Vhost::Redirect['dailybeast.com']
  -> Apache::Vhost::Redirect['havingtroublevoting.com']
  -> Apache::Vhost::Redirect['thisisyourreponguns.com']
  -> Apache::Vhost::Redirect['author.ec2.thedailybeast.com_80']
  -> Apache::Vhost::Redirect['author.ec2.thedailybeast.com_443']
  -> Apache::Vhost::Redirect['author.thedailybeast.com_80']
  -> Apache::Vhost::Redirect['womenintheworld.org']
  -> Apache::Vhost::Redirect['games.thedailybeast.com']
}
