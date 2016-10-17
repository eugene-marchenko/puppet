# Class: nginx::base
#
# Base nginx class. Installs package, runs service, defines main configuration file.
# Note that it doesn't modify, by default, the main configuration file,
# in order to do it, add a source|content statement for the relevant File type in this class or in a class that inherits it.
# This class is included by main nginx class, it's not necessary to call it directly

class nginx::base  {

        package { 'nginx':
                name    => 'nginx',
                require => Class['puppet'],
                ensure  => present,
        }

        service { 'nginx':
                name       => 'nginx',
                ensure     => running,
                enable     => true,
                pattern    => 'nginx',
                hasrestart => true,
                require    => Package['nginx'],
                subscribe  => File['default'],
        }

        file { 'default':
                mode    => '0644',
                owner   => root,
                group   => root,
                require => Package['nginx'],
                ensure  => present,
                path    => '/etc/nginx/sites-available/default',
                content => template('nginx/default.erb'),
        }

}
