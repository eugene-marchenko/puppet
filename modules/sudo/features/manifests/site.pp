# sudo::config::sudoer
node 'define-sudo-config-sudoer-default' {
  sudo::config::sudoer { 'sysadmins' : }
}

node 'define-sudo-config-sudoer-notfound' {
  sudo::config::sudoer { 'johndoe' : }
}

node 'define-sudo-config-sudoer-absent' {
  sudo::config::sudoer { 'sysadmins' : ensure => 'absent' }
}

node 'define-sudo-config-sudoer-from-template' {
  sudo::config::sudoer { 'johndoe' :
    template  => 'sudo/sudo_all_privs.erb',
  }
}

node 'define-sudo-config-sudoer-all-privs' {
  sudo::config::sudoer { 'johndoe' :
    template  => 'sudo/sudo_all_privs_no_pass.erb',
  }
}

node 'define-sudo-config-sudoers-from-content' {
  sudo::config::sudoer { 'defaults-insults' :
    content   => 'Defaults insults'
  }
}

# sudo::config
node 'class-sudo-config-default' {
  include sudo::config
}

node 'class-sudo-config-custom-users' {
  class { 'sudo::config' : sudoers => [ 'johnny', 'bill' ] }
}

node 'class-sudo-config-sudoer-from-params' {
  class { 'sudo::config' : }
}

node 'class-sudo-config-sudoer-from-location-fact' {
  include sudo::config
}

node 'class-sudo-config-sudoers-absent' {
  class { 'sudo::config' : ensure => 'absent' }
}

# sudo::package
node 'class-sudo-package-default' {
  include sudo::package
}

node 'class-sudo-package-absent' {
  class { 'sudo::package' : ensure => 'absent' }
}

node 'class-sudo-diff-package-name' {
  class { 'sudo::package' : ensure => 'present' }
}

# sudo
node 'class-sudo-init-default' {
  include sudo
}

node 'class-sudo-init-location-development' {
  include sudo
}

node 'class-sudo-init-custom-users' {
  class { 'sudo' : sudoers => [ 'jack', 'jill' ] }
}

node 'class-sudo-init-sudoers-absent' {
  class { 'sudo' : sudoersensure => 'absent' }
}

node 'class-sudo-init-package-absent' {
  class { 'sudo' : packageensure => 'absent' }
}
