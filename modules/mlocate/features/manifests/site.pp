# class mlocate::packages
node 'class-mlocate-packages-default' {
  include mlocate::packages
}

node 'class-mlocate-packages-uninstalled' {
  class { 'mlocate::packages' : installed => false }
}

# class mlocate::configs
node 'class-mlocate-configs-default' {
  include mlocate::configs
}

node 'class-mlocate-configs-custom' {
  class { 'mlocate::configs' :
    prune_bind_mounts => false,
    prune_names       => 'foo bar baz',
    prune_paths       => [],
    prune_fs          => [],
  }
}

node 'class-mlocate-configs-uninstalled' {
  class { 'mlocate::configs' : installed => false }
}

# class mlocate::services
node 'class-mlocate-services-default' {
  include mlocate::services
}

node 'class-mlocate-services-disabled' {
  class { 'mlocate::services' : enabled => false }
}

node 'class-mlocate-services-stopped' {
  class { 'mlocate::services' : running => false }
}

# class mlocate
node 'class-mlocate-default' {
  include mlocate
}

node 'class-mlocate-uninstalled' {
  class { 'mlocate' : installed => false }
}
