# ssh nodes
node 'class-init-default' {
  class { 'ssh' : }
}

node 'class-init-installed' {
  class { 'ssh' : ensure => installed }
}

node 'class-init-uninstalled' {
  class { 'ssh' : ensure => uninstalled }
}

node 'class-init-custom-configs' {
  class { 'ssh' :
    ensure      => installed,
    configfiles => {
      '/etc/ssh/sshd_config' => {
        ensure  => 'link',
        target  => '/etc/ssh/sshd_config.dist',
        mode    => '0644',
        require => Class[ssh::package],
        notify  => Class[ssh::service],
      },
      '/etc/ssh/ssh_config'  => {
        ensure  => 'present',
        source  => 'puppet:///modules/ssh/ssh_config',
        mode    => '0644',
        require => Class[ssh::package],
      },
      '/etc/default/ssh'     => {
        ensure  => 'present',
        content => template('ssh/fixtures/test.erb'),
        mode    => '0644',
        require => Class[ssh::package],
        notify  => Class[ssh::service],
      },
    }
  }
}

node 'class-init-with-package-version' {
  class { 'ssh' :
    ensure        => installed,
    packageensure => '1:5.9p1-2ubuntu1',
  }
}

node 'class-init-with-package-purged' {
  class { 'ssh' :
    ensure        => uninstalled,
    packageensure => purged,
  }
}

node 'class-init-with-invalid-packageensure' {
  class { 'ssh' :
    ensure        => installed,
    packageensure => purged,
  }
}

node 'class-init-service-stopped' {
  class { 'ssh' :
    ensure        => installed,
    serviceensure => stopped,
    enable        => false,
  }
}

node 'class-init-pattern-hassstatus-true' {
  class { 'ssh' :
    ensure  => installed,
    pattern => 'foo',
  }
}

node 'class-init-status-hasstatus-true' {
  class { 'ssh' :
    ensure => installed,
    status => 'service foo status'
  }
}

node 'class-init-service-pattern' {
  class { 'ssh' :
    ensure    => installed,
    hasstatus => false,
    pattern   => 'foo',
  }
}

node 'class-init-service-status' {
  class { 'ssh' :
    ensure    => installed,
    hasstatus => false,
    status    => 'service foo status',
  }
}

node 'class-init-stage-deploy' {
  class { 'ssh' : ensure => installed, stage => deploy }
}

# ssh::params nodes
node 'class-params' {
  class { 'ssh::params' : }
}

node 'class-params-include-dup' {
  include ssh::params
  include ssh::params
}

node 'class-params-dup' {
  class { 'ssh::params' : }
  class { 'ssh::params' : }
}

node 'class-params-mix' {
  include ssh::params
  class { 'ssh::params' : }
}

node 'class-params-mix2' {
  class { 'ssh::params' : }
  include ssh::params
}

node 'class-params-with-parameter' {
  class { 'ssh::params' : parameter => 'should fail' }
}

node 'class-params-unsupported-puppetversion' {
  class { 'ssh::params' : }
}

# ssh::config nodes
node 'define-config-one-option' {
  class { 'ssh' : ensure => installed, augeas_managed => true, }
  ssh::config { 'ListenAddress' :
    config  => { 'ListenAddress' => {
                    ensure  => present,
                    file    => '/etc/ssh/sshd_config',
                    value   => $::ipaddress_lo,
                    require => Class[ssh],
                    notify  => Class[ssh::service],
                },
    },
  }
}

node 'define-config-multiple-options' {
  class { 'ssh' : ensure => installed, augeas_managed => true, }
  $my_config_opts = [ 'ListenAddress', 'PermitRootLogin' ]
  ssh::config { $my_config_opts :
    config  => {
      'ListenAddress'   => {
        ensure  => present,
        file    => '/etc/ssh/sshd_config',
        value   => $::ipaddress_lo,
        require => Class[ssh],
        notify  => Class[ssh::service],
      },
      'PermitRootLogin' => {
        ensure  => present,
        file    => '/etc/ssh/sshd_config',
        value   => 'no',
        require => Class[ssh],
        notify  => Class[ssh::service],
      },
    }
  }
}

node 'define-config-augeas-option-disabled' {
  class { 'ssh' : ensure => installed, augeas_managed => true, }
  ssh::config { 'Host[. = \'*\']/LoginGraceTime' :
    config  => {
      'Host[. = \'*\']/LoginGraceTime'   => {
        ensure  => absent,
        file    => '/etc/ssh/sshd_config',
        value   => $::fqdn,
        require => Class[ssh],
        notify  => Class[ssh::service],
      },
    }
  }
}

node 'define-config-forgotten-ssh-class' {
  ssh::config { 'ListenAddress' :
    config  => {
      'ListenAddress'   => {
        ensure  => present,
        file    => '/etc/ssh/sshd_config',
        value   => $::ipaddress_lo,
        require => Class[ssh],
        notify  => Class[ssh::service],
      },
    }
  }
}

node 'define-config-root-user' {
  $my_opts = [ 'Host', 'Host[. = \'*\']/ForwardAgent' ]
  ssh::config { $my_opts :
    config  => {
      'Host'                         => {
        ensure => present,
        file   => '/root/.ssh/config',
        lens   => 'Ssh.lns',
        value  => '*',
      },
      'Host[. = \'*\']/ForwardAgent' => {
        ensure  => present,
        file    => '/root/.ssh/config',
        lens    => 'Ssh.lns',
        value   => 'yes',
        require => Augeas['/root/.ssh/config-Host'],
      },
    },
  }
}

# ssh::config::file
node 'define-config-file' {
  class { 'ssh::config::default' :
    configfiles => {
      '/etc/ssh/sshd_config' => {
        mode    => '0644',
        require => undef,
        notify  => undef,
      },
      '/etc/ssh/ssh_config'  => {
        mode    => '0644',
        require => undef,
        notify  => undef,
      },
      '/etc/default/ssh'     => {
        mode    => '0644',
        require => undef,
        notify  => undef,
      },
    }
  }
}

node 'define-config-file-custom' {
  ssh::config::file { '/root/.ssh/config' :
    config => { '/root/.ssh/config' => {
                  mode    => '0644',
                  content => template('ssh/fixtures/test.erb'),
      },
    }
  }
}
