# define ruby::package
node 'define-ruby-package-default' {
  include ruby::params
  $packages_hash = $ruby::params::packages
  $packages = keys($packages_hash)
  ruby::package { $packages : }
}

node 'define-ruby-package-custom-packages' {
  ruby::package { [ 'foo', 'bar' ]: }
}

node 'define-ruby-package-gem-provider' {
  ruby::package { 'aws-sdk': ensure => 'present', provider => 'gem' }
}

# class ruby::package::base

node 'class-ruby-package-base-default' {
  class { 'ruby::package::base' : }
}

node 'class-ruby-package-base-custom-packages' {
  class { 'ruby::package::base' : packages => {
      'bar' => {
        'ensure'  => 'latest',
      },
      'foo' => {
        'ensure'  => 'latest',
      },
    }
  }
}

# class ruby

node 'class-ruby' {
  include ruby
}

node 'class-ruby-uninstalled' {
  class { 'ruby' : installed => false }
}

node 'class-ruby-installed-invalid' {
  class { 'ruby' : installed => yes }
}

node 'class-ruby-custom-packages' {
  class { 'ruby' : packages => hiera('custom_packages') }
}

node 'class-ruby-complex-chaining-example' {
  include ruby
  ruby::package { 'nokogiri': ensure => absent, provider => 'gem' }
  ruby::package { 'aws-sdk' : ensure => present, provider => 'gem' }

  Class[ruby]               -> Ruby::Package['nokogiri']
  Ruby::Package['nokogiri'] -> Ruby::Package['aws-sdk']
}

# class ruby::gem::packages

node 'class-ruby-gem-packages-default' {
  include ruby::gem::packages
}

node 'class-ruby-gem-packages-realized' {
  include ruby::gem::packages
  realize Package[curb]
  realize Package[nokogiri]
  realize Package[highline]
}

node 'class-ruby-gem-packages-collection' {
  include ruby::gem::packages
  Package <| title == 'curb' |> {
    ensure  => '1.0.1'
  }
  Package <| title == 'nokogiri' |> {
    ensure  => '1.0.1'
  }
  Package <| title == 'highline' |> {
    ensure  => '1.0.1'
  }
}
