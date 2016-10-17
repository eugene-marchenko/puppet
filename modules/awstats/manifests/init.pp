# Class: awstats
#
# Manages awstats.
# Include it to install and run awstats with default settings
#
# Usage:
# include awstats

class awstats {

   package { 'awstats':
        ensure  => installed,
        require => Class['puppet'],
   }

   awstats::awstats_files {

   '/etc/awstats/awstats.conf':
         source => 'awstats.conf';

   '/etc/awstats/awstats.www.newsweek.com.conf':
         source => 'awstats.www.newsweek.com.conf';

   }
   }
