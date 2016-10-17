# define mysql::package
node 'mysql-package-default' {
  include mysql::params
  mysql::package { 'mysql-packages':
    packages => $mysql::params::mysql_client_packages,
    defaults => $mysql::params::mysql_package_defaults,
  }
}

node 'mysql-package-no-params' {
  mysql::package { 'mysql-packages': }
}

# class mysql
node 'class-mysql-default' {
  include mysql
}

node 'class-mysql-uninstalled' {
  class { 'mysql' : installed => false }
}

node 'class-mysql-installed-invalid' {
  class { 'mysql' : installed => yes }
}

# class mysql::backup
node 'mysql-backup-default' {
  class { 'mysql::backup' : }
}

node 'mysql-backup-required-params' {
  class { 'mysql::backup' : accesskey => 'FOO', secretkey => 'BAR' }
}

node 'mysql-backup-from-source-diff-path' {
  class { 'mysql::backup' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    path      => '/usr/bin/snapshot.pl',
    source    => 'puppet:///modules/mysql/scripts/backup.pl'
  }
}

node 'mysql-backup-from-content' {
  class { 'mysql::backup' :
    accesskey => 'FOO',
    secretkey => 'BAR',
    content   => 'foo',
  }
}

node 'mysql-backup-uninstalled' {
  class { 'mysql::backup' :
    installed => false,
    accesskey => 'FOO',
    secretkey => 'BAR',
  }
}
