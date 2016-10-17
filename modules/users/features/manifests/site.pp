# users::manage::users
node 'define-user-complete-config' {
  users::manage::user { 'johndoe' :
    config  => {
      'johndoe' => {
        'ensure'   => 'present',
        'uid'      => '2000',
        'gid'      => 'users',
        'groups'   => [ 'operator', 'adm' ],
        'shell'    => '/bin/bash',
        'home'     => '/home/johndoe',
        'password' => '$1AAAAAAAAAAAAAAAAAAAAAA',
        'comment'  => 'John Doe',
        },
    },
  }
}

node 'define-user-incomplete-config' {
  users::manage::user { 'johndoe' :
    config  => {
      'johndoe' => {
        'ensure' => 'present',
        'uid'    => '2000',
        },
    },
  }
}

node 'define-user-ensure-overriden' {
  users::manage::user { 'johndoe' :
    config => {
      'johndoe' => {
        'ensure' => 'present',
        'uid'    => '2000',
        },
    },
    ensure => 'absent',
  }
}

node 'define-user-system-user' {
  users::manage::user { 'jetty' :
    config => {
      'jetty' => {
        'ensure' => 'present',
        'uid'    => '50',
        'gid'    => '65534',
        'home'   => '/usr/share/jetty',
        'shell'  => '/bin/false',
        },
    },
    system => true,
  }
}

node 'define-user-invalid-ensure' {
  users::manage::user { 'johndoe' :
    config  => {
      'johndoe' => {
        'ensure' => 'latest',
        'uid'    => '2000',
        'gid'    => '100',
        },
    },
  }
}

node 'define-user-no-config' {
  users::manage::user { 'janedoe' : }
}

# users::manage::group
node 'define-group-complete-config' {
  users::manage::group { 'sysadmins' :
    config  => {
      'sysadmins' => {
        'ensure' => 'present',
        'gid'    => '501',
        },
    },
  }
}

node 'define-group-incomplete-config' {
  users::manage::group { 'developers' :
    config  => {
      'developers' => {
        'ensure' => 'present',
        },
    },
  }
}

node 'define-group-ensure-overriden' {
  users::manage::group { 'contractors' :
    config => {
      'contractors' => {
        'ensure' => 'present',
        'gid'    => '2000',
        },
    },
    ensure => 'absent',
  }
}

node 'define-group-system-group' {
  users::manage::group { 'jetty' :
    config => {
      'jetty' => {
        'ensure' => 'present',
        'gid'    => '48',
        },
    },
    system => true,
  }
}

node 'define-group-invalid-ensure' {
  users::manage::group { 'contractors' :
    config  => {
      'contractors' => {
        'ensure' => 'latest',
        'gid'    => '100',
        },
    },
  }
}

node 'define-group-no-config' {
  users::manage::group { 'developers' : }
}

# users::manage::sshkey
node 'define-sshkey-complete-config' {
  users::manage::sshkey { 'johndoe' :
    config => {
      'johndoe' => {
        'ssh_pub_key_ensure'  => 'present',
        'ssh_pub_key_type'    => 'ssh-dss',
        'ssh_pub_key'         => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAzJTjwUBZ',
        'ssh_pub_key_options' => '',
        },
    },
  }
}

node 'define-sshkey-incomplete-config' {
  users::manage::sshkey { 'johndoe' :
    config => {
      'johndoe' => {
        'ssh_pub_key_ensure' => 'present',
        'ssh_pub_key'        => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAzJTjwUBZ',
        },
    },
  }
}

node 'define-sshkey-ensure-overriden' {
  users::manage::sshkey { 'johndoe' :
    config => {
      'johndoe' => {
        'ssh_pub_key_ensure'  => 'present',
        'ssh_pub_key_type'    => 'ssh-rsa',
        'ssh_pub_key'         => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAzJTjwUBZ',
        'ssh_pub_key_options' => '',
        },
    },
    ensure => 'absent',
  }
}

node 'define-sshkey-invalid-ensure' {
  users::manage::sshkey { 'johndoe' :
    config => {
      'johndoe' => {
        'ssh_pub_key_ensure' => 'latest',
        'ssh_pub_key'        => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAzJTjwUBZ',
        },
    },
  }
}

node 'define-sshkey-invalid-type' {
  users::manage::sshkey { 'johndoe' :
    config => {
      'johndoe' => {
        'ssh_pub_key_ensure' => 'present',
        'ssh_pub_key'        => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAzJTjwUBZ',
        'ssh_pub_key_type'   => 'ssh-rss',
        },
    },
  }
}

node 'define-sshkey-no-config' {
  users::manage::sshkey { 'janedoe' : }
}

# users::groups
node 'class-user-groups' {
  include users::groups
}

node 'class-user-groups-hiera' {
  class { 'users::groups' : override => true }
}

node 'class-user-groups-hiera-diff-key' {
  class { 'users::groups' : override => true, key => 'unix_groups' }
}

node 'class-user-groups-hiera-diff-key-not-found' {
  class { 'users::groups' : override => true, key => 'solaris_groups' }
}

# users::manage
node 'define-manage-sysadmins-from-params' {
  users::manage { 'sysadmins' : }
}

node 'define-manage-sysadmins-from-hiera' {
  users::manage { 'sysadmins' :  override => true }
}

node 'define-manage-sysadmins-no-ssh' {
  users::manage { 'sysadmins' : override => true, manage_ssh => false }
}

node 'define-manage-multiple-user-types' {
  $groups = [ 'sysadmins', 'developers' ]
  users::manage { $groups : override => true }
}

node 'define-manage-users-from-group-not-found' {
  users::manage { 'contractors' : override => true }
}

# users
node 'class-user-init-default' {
  include users
}

node 'class-user-init-hiera' {
  class { 'users' : override => true }
}

node 'class-user-init-hiera-multiple-groups' {
  class { 'users' : users => [ 'sysadmins', 'developers' ], override => true }
}

node 'class-user-init-non-standard-groupkey' {
  class { 'users' :
    users     => [ 'wheel' ],
    group_key => 'unix_groups',
    override  => true
  }
}
