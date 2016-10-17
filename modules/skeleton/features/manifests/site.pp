# class skeleton::packages
node 'class-skeleton-packages-default' {
  include skeleton::packages
}

node 'class-skeleton-packages-uninstalled' {
  class { 'skeleton::packages': installed => false }
}

# class skeleton::configs
node 'class-skeleton-configs-default' {
  include skeleton::configs
}

node 'class-skeleton-configs-uninstalled' {
  class { 'skeleton::configs': installed => false }
}

# class skeleton::services
node 'class-skeleton-services-default' {
  include skeleton::services
}

node 'class-skeleton-services-disabled' {
  class { 'skeleton::services' : enabled => false }
}

node 'class-skeleton-services-stopped' {
  class { 'skeleton::services' : running => false }
}

# class skeleton
node 'class-skeleton-default' {
  include skeleton
}

node 'class-skeleton-uninstalled' {
  class { 'skeleton' : installed => false }
}
