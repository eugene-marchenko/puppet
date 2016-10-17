# class java::packages
node 'class-java-packages-default' {
  include java::packages
}

node 'class-java-packages-uninstalled' {
  class { 'java::packages': installed => false }
}

node 'class-java-packages-diff-version' {
  class { 'java::packages': version => 'foo-version' }
}

node 'class-java-packages-diff-uninstall-overrides' {
  class { 'java::packages':
    version   => 'foo-version',
    installed => false
  }
}

# class java
node 'class-java-default' {
  include java
}

node 'class-java-uninstalled' {
  class { 'java' : installed => false }
}
