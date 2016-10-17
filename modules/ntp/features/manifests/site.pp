# class ntp::packages
node 'class-ntp-packages-default' {
  include ntp::packages
}

node 'class-ntp-packages-uninstalled' {
  class { 'ntp::packages': installed => false }
}

# class ntp::configs
node 'class-ntp-configs-default' {
  include ntp::configs
}

node 'class-ntp-configs-uninstalled' {
  class { 'ntp::configs': installed => false }
}

# class ntp::services
node 'class-ntp-services-default' {
  include ntp::services
}

node 'class-ntp-services-disabled' {
  class { 'ntp::services' : enabled => false }
}

node 'class-ntp-services-stopped' {
  class { 'ntp::services' : running => false }
}

# class ntp
node 'class-ntp-default' {
  include ntp
}

node 'class-ntp-uninstalled' {
  class { 'ntp' : installed => false }
}
