# define perl::package
node 'define-perl-package-default' {
  include perl::params
  $packages_hash = $perl::params::perl_packages
  $packages = keys($packages_hash)
  perl::package { $packages : }
}

node 'define-perl-package-custom-packages' {
  perl::package { [ 'foo', 'bar' ]: }
}

# class perl::package::base
node 'class-perl-package-base-default' {
  include perl::package::base
}

node 'class-perl-package-base-custom-packages' {
  class { 'perl::package::base' : packages => {
      'bar' => {
        'ensure' => 'latest',
      },
      'foo' => {
        'ensure' => 'latest',
      },
    }
  }
}

# class perl

node 'class-perl' {
  include perl
}

node 'class-perl-uninstalled' {
  class { 'perl' : installed => false }
}

node 'class-perl-installed-invalid' {
  class { 'perl' : installed => yes }
}

node 'class-perl-packages-custom' {
  class { 'perl' : packages => hiera('custom_packages') }
}

node 'class-perl-complex-chaining-example' {
  include perl
  perl::package { 'libxml-simple-perl':
    ensure   => '2.18-3',
    provider => 'apt'
  }
  perl::package { 'libnet-amazon-ec2-perl':
    ensure   => '0.14-1',
    provider => 'apt'
  }

  Class[perl]                         -> Perl::Package['libxml-simple-perl']
  Perl::Package['libxml-simple-perl'] -> Perl::Package['libnet-amazon-ec2-perl']
}
