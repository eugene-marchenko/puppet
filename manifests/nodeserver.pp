class nodeserver() {
  notify { 'inside statement 2' : message => "Test in roles", }
  class { 'nodejs':
    version => 'latest',
  }
}