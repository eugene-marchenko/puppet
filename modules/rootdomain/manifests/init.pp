# Class: rootdomain
#
# Usage:
# include rootdomain

class rootdomain {

    file {
        '/usr/local/bin/register_eip.py':
            mode   => '0755',
            owner  => root,
            group  => root,
            ensure => present,
            source => 'puppet:///modules/rootdomain/register_eip.py',
    }

    exec {
        'register_eip':
            require => [ Class['ec2::boto'], Class['ec2::certs'], Class['ec2::environment'], Class['ec2::apitools'], Class['python::base'], File['/usr/local/bin/register_eip.py'], ],
            command => '/usr/local/bin/register_eip.py',
    }

}
