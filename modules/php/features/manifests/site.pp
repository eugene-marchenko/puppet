# define php::base::packages
node 'php-base-packages-default' {
  include php::params
  php::base::packages { 'php-base-packages':
    packages => $php::params::php_base_packages,
    defaults => $php::params::php_base_package_defaults,
  }
}

node 'php-base-packages-no-params' {
  php::base::packages { 'php-base-packages': }
}

# define php::config
node 'php-config-default' {
  php::config { '/etc/php5/cli/conf.d/foo.ini' :
    content => "foo = 10\n",
  }
}

node 'php-config-no-params' {
  php::config { '/etc/php5/cli/conf.d/foo.ini' : }
}

# class php

node 'class-php-default' {
  include php
}

node 'class-php-uninstalled' {
  class { 'php' : installed => false }
}

node 'class-php-installed-invalid' {
  class { 'php' : installed => yes }
}

# class php::packages
node 'class-php-packages-default' {
  include php::packages
  realize Package[php5-mysql]
  Package <| title == 'php5-mcrypt' |> {
    ensure    => '1.1.1',
    provider  => 'apt',
  }
}
