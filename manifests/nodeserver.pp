class nodeserver() {
  notify { 'inside statement 2' : message => "Test in roles", }
  class { '::nodejs':
    nodejs_dev_package_ensure => 'present',
    npm_package_ensure        => 'present',
    repo_class                => '::epel',
  }
}