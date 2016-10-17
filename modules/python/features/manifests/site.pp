# define python::package
node 'define-python-package-default' {
  include python::params
  $packages_hash = $python::params::python_packages
  $packages = keys($packages_hash)
  python::package { $packages : }
}

node 'define-python-package-custom-packages' {
  python::package { [ 'foo', 'bar' ]: }
}

node 'define-python-package-pip-provider' {
  python::package { 'cirrus': ensure => 'present', provider => 'pip' }
}

# class python::package::base
node 'class-python-package-base-default' {
  include python::package::base
}

node 'class-python-package-base-custom-packages' {
  class { 'python::package::base' : packages => {
      'bar' => {
        'ensure' => 'latest',
      },
      'foo' => {
        'ensure' => 'latest',
      },
    }
  }
}

# class python

node 'class-python' {
  include python
}

node 'class-python-uninstalled' {
  class { 'python' : installed => false }
}

node 'class-python-installed-invalid' {
  class { 'python' : installed => yes }
}

node 'class-python-packages-custom' {
  class { 'python' : packages => hiera('custom_packages') }
}

node 'class-python-complex-chaining-example' {
  include python
  python::package { 'mechanize' : ensure => '1.0.0', provider => 'pip' }
  python::package { 'jinja2'    : ensure => '0.2.0', provider => 'pip' }

  Class[python]             -> Python::Package['jinja2']
  Python::Package['jinja2'] -> Python::Package['mechanize']
}

# class python::pip::packages

node 'class-python-pip-packages-default' {
  include python::pip::packages
}

node 'class-python-pip-packages-realized' {
  include python::pip::packages
  realize Package[BeautifulSoup]
  realize Package[jinja2]
  realize Package[lxml]
  realize Package[mechanize]
  realize Package[simplejson]
  realize Package[pysolr]
  realize Package[pycurl]
  realize Package[pyyaml]
  realize Package[nose]
  realize Package[html2text]
  realize Package[jenkinsapi]
  realize Package[jprops]
}

node 'class-python-pip-packages-collection' {
  include python::pip::packages
  Package <| title == 'BeautifulSoup' |> {
    ensure  => '1.0.1'
  }
  Package <| title == 'jinja2' |> {
    ensure  => '1.0.1'
  }
  Package <| title == 'lxml' |> {
    ensure  => '1.0.1'
  }
  Package <| title == 'mechanize' |> {
    ensure  => '1.0.1'
  }
  Package <| title == 'simplejson' |> {
    ensure  => '1.0.1'
  }
  Package <| title == 'pysolr' |> {
    ensure  => '1.0.1'
  }
  Package <| title == 'jenkinsapi' |> {
    ensure  => '1.0.1'
  }
  Package <| title == 'jprops' |> {
    ensure  => '1.0.1'
  }
}
