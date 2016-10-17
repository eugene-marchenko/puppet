# define apache::package
node 'apache-package-default' {
  include apache::params
  apache::package { 'apache-packages' :
    packages => $apache::params::apache_packages,
    defaults => $apache::params::apache_package_defaults,
  }
}

node 'apache-package-no-params' {
  apache::package { 'apache-packages' : }
}

# define apache::config
node 'apache-config-default' {
  include apache::params
  apache::config { 'apache-configs' :
    configs => $apache::params::apache_configs,
  }
}

node 'apache-config-no-params' {
  apache::config { 'apache-configs' : }
}

# define apache::service
node 'apache-service-default' {
  include apache::service
}

node 'apache-service-uninstalled' {
  class { 'apache::service' : installed => false }
}

# class apache
node 'class-apache-default' {
  include apache
}

node 'class-apache-uninstalled' {
  class { 'apache' : installed => false }
}

# class apache::mod::python
node 'class-apache-mod-python-default' {
  include apache::mod::python
}

node 'class-apache-mod-python-invalid-hash' {
  class { 'apache::mod::python' : packages => [ ] }
}

node 'class-apache-mod-python-uninstalled' {
  class { 'apache::mod::python' : installed => false }
}

# class apache::mod::wsgi
node 'class-apache-mod-wsgi-default' {
  include apache::mod::wsgi
}

node 'class-apache-mod-wsgi-invalid-hash' {
  class { 'apache::mod::wsgi' : packages => [ ] }
}

node 'class-apache-mod-wsgi-uninstalled' {
  class { 'apache::mod::wsgi' : installed => false }
}

# class apache::mod::php
node 'class-apache-mod-php-default' {
  include apache::mod::php
}

node 'class-apache-mod-php-invalid-hash' {
  class { 'apache::mod::php' : packages => [ ] }
}

node 'class-apache-mod-php-uninstalled' {
  class { 'apache::mod::php' : installed => false }
}

# class apache::mod::passenger
node 'class-apache-mod-passenger-default' {
  include apache::mod::passenger
}

node 'class-apache-mod-passenger-invalid-hash' {
  class { 'apache::mod::passenger' : packages => [ ] }
}

node 'class-apache-mod-passenger-uninstalled' {
  class { 'apache::mod::passenger' : installed => false }
}

# class apache::ssl
node 'class-apache-ssl-default' {
  include apache::ssl
}

node 'class-apache-ssl-uninstalled' {
  class { 'apache::ssl' : installed => false }
}

# define apache::vhost
node 'apache-vhost-default' {
  include apache
  apache::vhost { 'default':
    port    => '80',
    docroot => '/var/www',
  }
}

node 'apache-vhost-redirect-to-ssl' {
  include apache
  apache::vhost { 'default':
    port         => '80',
    servername   => $::hostname,
    redirect_ssl => true,
    docroot      => '/var/www',
  }

  apache::vhost { 'default-ssl':
    port       => '443',
    servername => $::hostname,
    ssl        => true,
    docroot    => '/var/www',
  }
}

node 'apache-vhost-non-defaults' {
  include apache
  apache::vhost { 'diff-priority':
    port     => '80',
    priority => '25',
    docroot  => '/var/www',
  }

  apache::vhost { 'diff-srvname':
    port       => '80',
    servername => 'foo.bar.com',
    docroot    => '/var/www',
  }

  apache::vhost { 'with-serveraliases-string':
    port          => '80',
    servername    => 'foo.bar.com',
    serveraliases => 'baz.bar.com',
    docroot       => '/var/www',
  }

  apache::vhost { 'with-serveraliases-array':
    port          => '80',
    servername    => 'foo.bar.com',
    serveraliases => [ 'baz.bar.com', 'qux.bar.com' ],
    docroot       => '/var/www',
  }

  apache::vhost { 'with-options':
    port    => '80',
    options => 'All',
    docroot => '/var/www',
  }

  apache::vhost { 'diff-log-dir':
    port    => '80',
    log_dir => '/mnt/log/apache2',
    docroot => '/var/www',
  }

  apache::vhost { 'diff-vhost-name':
    port       => '80',
    vhost_name => 'foo.bar.com',
    docroot    => '/var/www',
  }

  apache::vhost { 'diff-ports-conf':
    port       => '80',
    ports_conf => '/etc/apache2/ports-custom.conf',
    docroot    => '/var/www',
  }

  apache::vhost { 'diff-template':
    port     => '80',
    template => 'apache/vhost/default.conf.erb',
    docroot  => '/var/www',
  }

  apache::vhost { 'diff-allow':
    port    => '80',
    allow   => [ '127.0.0.0/8', '169.254.169.0/24' ],
    docroot => '/var/www',
  }
}

node 'apache-vhost-no-params' {
  include apache
  apache::vhost { 'no-params' : }
}

node 'apache-vhost-invalid-ssl-bool' {
  include apache
  apache::vhost { 'invalid-ssl-bool' :
    port    => '80',
    docroot => '/var/www',
    ssl     => 'yes',
  }
}

node 'apache-vhost-invalid-redirect_ssl-bool' {
  include apache
  apache::vhost { 'invalid-ssl-bool' :
    port         => '80',
    docroot      => '/var/www',
    redirect_ssl => 'yes',
  }
}

node 'apache-vhost-invalid-enable-bool' {
  include apache
  apache::vhost { 'invalid-ssl-bool' :
    port    => '80',
    docroot => '/var/www',
    enable  => 'yes',
  }
}

node 'apache-vhost-disabled' {
  include apache
  apache::vhost { 'foo.bar.com' :
    port    => '80',
    docroot => '/var/www',
    enable  => false,
  }
}

node 'apache-vhost-default-vhost' {
  include apache::vhost::default
}

node 'apache-vhost-default-vhost-realized' {
  include apache::vhost::default
  Apache::Vhost <| title == 'default' |> {
    enable => false,
  }
}

node 'apache-proxy-default' {
  include apache
  apache::vhost::proxy { 'foo.bar.com' :
    port    => '80',
    docroot => '/var/www',
    dest    => 'http://foo.bar.com:8080'
  }
}

node 'apache-proxy-ssl' {
  include apache
  apache::vhost::proxy { 'foo.bar.com' :
    port    => '443',
    ssl     => true,
    docroot => '/var/www',
    dest    => 'http://foo.bar.com:8080',
  }
}

node 'apache-proxy-deny' {
  include apache
  apache::vhost::proxy { 'foo.bar.com' :
    port       => '80',
    servername => 'foo.bar.com',
    docroot    => '/var/www',
    dest       => 'http://foo.bar.com:8080',
    proxy_deny => '/robots.txt',
  }

  apache::vhost::proxy { 'baz.bar.com' :
    port       => '80',
    servername => 'baz.bar.com',
    docroot    => '/var/www',
    dest       => 'http://foo.bar.com:8080',
    proxy_deny => [ '/robots.txt', '/favicon.ico' ]
  }
}

node 'apache-proxy-no-preserve-host' {
  include apache
  apache::vhost::proxy { 'foo.bar.com' :
    port                => '80',
    docroot             => '/var/www',
    dest                => 'http://foo.bar.com:8080',
    proxy_preserve_host => 'Off',
  }
}

node 'apache-proxy-with-auth' {
  include apache
  apache::vhost::proxy { 'foo.bar.com' :
    port       => '80',
    docroot    => '/var/www',
    dest       => 'http://foo.bar.com:8080',
    proxy_auth => true,
  }
  apache::vhost::proxy { 'baz.bar.com' :
    port                => '80',
    docroot             => '/var/www',
    dest                => 'http://foo.bar.com:8080',
    proxy_auth          => true,
    proxy_auth_type     => 'ldap',
    proxy_auth_name     => 'foo',
    proxy_auth_userfile => '/var/www/baz.bar.com/pw.file',
  }
}

node 'apache-proxy-custom-headers' {
  include apache
  apache::vhost::proxy { 'foo.bar.com' :
    port                 => '80',
    docroot              => '/var/www',
    dest                 => 'http://foo.bar.com:8080',
    header_set           => [ 'MyHeader=Hello' ],
    header_unset         => [ 'Set-Cookie' ],
    request_header_set   => [ 'Foo=Bar', 'Baz:Qux' ],
    request_header_unset => [ 'Cookie' ],

  }
}

node 'apache-proxy-no-params' {
  include apache
  apache::vhost::proxy { 'foo.bar.com' : }
}

node 'apache-redirect-default' {
  include apache
  apache::vhost::redirect { 'foo.bar.com' :
    port => '80',
    dest => 'http://baz.bar.com',
  }
}

node 'apache-redirect-temporary' {
  include apache
  apache::vhost::redirect { 'foo.bar.com' :
    port   => '80',
    dest   => 'http://baz.bar.com',
    status => 'temp',
  }
}

node 'apache-redirect-no-params' {
  include apache
  apache::vhost::redirect { 'foo.bar.com' : }
}

node 'apache-redirect-ssl-enabled' {
  include apache
  apache::vhost::redirect { 'foo.bar.com' :
    port => '443',
    ssl  => true,
    dest => 'https://baz.bar.com',
  }
}

# class apache::dispatcher
node 'class-apache-dispatcher-default' {
  include apache::dispatcher
}

node 'class-apache-dispatcher-uninstalled' {
  class { 'apache::dispatcher' : installed  => false }
}

# define apache::dispatcher::vhost::file
node 'apache-dispatcher-vhost-file-template' {
  apache::dispatcher::vhost::file { 'foo.txt' :
    servername => 'www.example.com',
    template   => 'apache/dispatcher/dispatcher.conf.erb',
  }
}

node 'apache-dispatcher-vhost-file-content' {
  apache::dispatcher::vhost::file { 'foo.txt' :
    servername => 'www.example.com',
    content    => 'foo',
  }
}

node 'apache-dispatcher-vhost-file-source' {
  apache::dispatcher::vhost::file { 'foo.txt' :
    servername => 'www.example.com',
    source     => 'puppet:///modules/apache/some/file.txt',
  }
}

node 'apache-dispatcher-vhost-file-diff-path' {
  apache::dispatcher::vhost::file { 'foo.txt' :
    servername => 'www.example.com',
    path       => '/tmp/foo.txt',
    content    => 'foo',
  }
}

node 'apache-dispatcher-vhost-file-invalid' {
  apache::dispatcher::vhost::file { 'foo.txt' :
    servername  => 'www.example.com',
  }
}

node 'apache-dispatcher-vhost-file-removed' {
  apache::dispatcher::vhost::file { 'foo.txt' :
    ensure     => 'absent',
    servername => 'www.example.com',
    content    => 'foo',
  }
}

# define apache::dispatcher::vhost
node 'apache-dispatcher-vhost-default-vhost' {
  include apache
  include apache::dispatcher
  apache::dispatcher::vhost { 'www.example.com' :
    port          => '80',
    renders       => [ 'rend01.example.com:8080',
                        'rend02.example.com'
                      ],
    docroot       => '/mnt/dispatcher/www.example.com',
    default_vhost => true,
    priority      => '000',
    serveraliases => [ '*.www.example.com', '*.example.*' ],
  }
}

node 'apache-dispatcher-vhost-two-vhosts' {
  include apache
  include apache::dispatcher
  apache::dispatcher::vhost { 'www.example.com' :
    port          => '443',
    renders       => [ 'rend01.example.com:8080',
                        'rend02.example.com'
                      ],
    docroot       => '/mnt/dispatcher/www.example.com',
    default_vhost => true,
    priority      => '000',
    serveraliases => [ '*.www.example.com', 'example.*' ],
  }
  apache::dispatcher::vhost { 'services.example.com' :
    port            => '80',
    renders         => [ 'rend03.example.com:8080',
                        'rend03.example.com:8081',
                        'rend04.example.com:8080',
                        'rend04.example.com:8081',
                      ],
    docroot         => '/mnt/dispatcher/services.example.com',
    d_tmpl_priority => '15',
    priority        => '05',
    serveraliases   => '*.services.example.*',
  }
}

node 'apache-dispatcher-vhost-disabled-vhost' {
  include apache
  include apache::dispatcher
  apache::dispatcher::vhost { 'www.example.com' :
    enable        => false,
    port          => '80',
    renders       => [ 'rend01.example.com:8080',
                        'rend02.example.com'
                      ],
    docroot       => '/mnt/dispatcher/www.example.com',
    default_vhost => true,
    priority      => '000',
    serveraliases => [ '*.www.example.com', 'example.*' ],
  }
}
