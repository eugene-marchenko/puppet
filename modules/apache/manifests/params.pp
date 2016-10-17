# = Class: apache::params
#
# This module manages default parameters. It does the heavy lifting
# to determine operating system specific parameters.
#
# == Parameters:
#
# None.
#
# == Actions:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# class apache::someclass( packages = $apache::params::some_param
# ) inherits apache::params {
# ...do something
# }
#
# class { 'apache::params' : }
#
# include apache::params
#
class apache::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports apache version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    # Parameter defaults
    $apache_root = '/etc/apache2'
    $apache_ssl_path = '/etc/ssl'
    $apache_ssl_prv_key_tdb = "${apache_ssl_path}/private/apache-ssl-key-tdb.key"
    $apache_ssl_prv_key = "${apache_ssl_path}/private/apache-ssl-key.key"
    $apache_ssl_cert = "${apache_ssl_path}/certs/apache-ssl-cert.pem"
    $apache_ssl_intermediate_cert = "${apache_ssl_path}/certs/apache-ssl-chain.pem"
    $apache_ssl_intermediate_cert_tdb = "${apache_ssl_path}/certs/apache-ssl-chain-tdb.pem"
    $apache_ssl_cert_tdb = "${apache_ssl_path}/certs/apache-ssl-cert-tdb.pem"

    $apache_log_dir = $::apache_log_dir ? {
      /''|undef/  => '/var/log/apache2',
      default     => $::apache_log_dir,
    }

    # Resource defaults
    $apache_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'apache-package',
    }
    $apache_module_defaults = {
      'ensure'  => 'present',
      'tag'     => 'apache-module',
    }
    $apache_services = {
      'apache2' => {
        'ensure'  => 'running',
        'enable'  => true,
      }
    }
    $apache_packages = {
      'apache2'           => {},
      'apache2-utils'     => {},
      'apache2.2-bin'     => {},
      'apache2.2-common'  => {},
      'libapache2-modsecurity' => {},
    }
    $apache_dev_packages = {
      'libaprutil1-dev'     => {},
      'libapr1-dev'         => {},
      'apache2-prefork-dev' => {},
    }
    $apache_mod_python_packages = {
      'libapache2-mod-python' => {},
    }
    $apache_mod_wsgi_packages = {
      'libapache2-mod-wsgi' => {},
    }
    $apache_mod_php_packages = {
      'libapache2-mod-php5' => {},
    }
    $apache_mod_passenger_packages = {
      'libapache2-mod-passenger' => {},
    }
    $apache_modules = {
      items => [
        'actions',
        'alias',
        'asis',
        'auth_basic',
        'auth_digest',
        'authn_alias',
        'authn_anon',
        'authn_dbd',
        'authn_dbm',
        'authn_default',
        'authn_file',
        'authnz_ldap',
        'authz_dbm',
        'authz_default',
        'authz_groupfile',
        'authz_host',
        'authz_owner',
        'authz_user',
        'autoindex',
        'cache',
        'cern_meta',
        'cgid',
        'cgi',
        'charset_lite',
        'dav_fs',
        'dav',
        'dav_lock',
        'dbd',
        'deflate',
        'dir',
        'disk_cache',
        'dump_io',
        'env',
        'expires',
        'ext_filter',
        'file_cache',
        'filter',
        'headers',
        'ident',
        'imagemap',
        'include',
        'info',
        'ldap',
        'log_forensic',
        'mem_cache',
        'mime',
        'mime_magic',
        'negotiation',
        'proxy_ajp',
        'proxy_balancer',
        'proxy_connect',
        'proxy_ftp',
        'proxy_http',
        'proxy',
        'proxy_scgi',
        'reqtimeout',
        'rewrite',
        'setenvif',
        'speling',
        'ssl',
        'status',
        'substitute',
        'suexec',
        'unique_id',
        'userdir',
        'usertrack',
        'version',
        'vhost_alias',
      ],
    }
    $apache_configs = {
      '/etc/default/apache2'              => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('apache/Ubuntu/precise/default.erb'),
          default   => template('apache/Ubuntu/default.erb'),
        }
      },
      "${apache_root}/apache2.conf"         => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('apache/Ubuntu/precise/apache2.conf.erb'),
          default   => template('apache/Ubuntu/apache2.conf.erb'),
        }
      },
      "${apache_root}/envvars"              => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('apache/Ubuntu/precise/envvars.erb'),
          default   => template('apache/Ubuntu/envvars.erb'),
        }
      },
      "${apache_root}/conf.d/security"      => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('apache/Ubuntu/precise/conf.d/security.erb'),
          default   => template('apache/Ubuntu/conf.d/security.erb'),
        }
      },
      "${apache_root}/conf.d/charset"       => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('apache/Ubuntu/precise/conf.d/charset.erb'),
          default   => template('apache/Ubuntu/conf.d/charset.erb'),
        }
      },
      "${apache_root}/conf.d/host_logging"  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('apache/Ubuntu/precise/conf.d/host_logging.erb'),
          default   => template('apache/Ubuntu/conf.d/host_logging.erb'),
        }
      },
      "${apache_log_dir}"               => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'adm',
        'mode'    => '0755',
      },
      '/etc/logrotate.d/apache2'      => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('apache/Ubuntu/precise/logrotate.conf.erb'),
          default   => template('apache/Ubuntu/logrotate.conf.erb'),
        }
      },
      '/etc/apache2/auth_map.txt'     => {
        ensure  => 'present',
        source => 'puppet:///modules/apache/auth_map.txt',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
      },
}

    $apache_ssl_files = {
      "${apache_ssl_prv_key}"           => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'ssl-cert',
        'mode'    => '0640',
        'source'  => 'puppet:///modules/data/apache/ssl/ssl-private.key',
      },
      "${apache_ssl_prv_key_tdb}"           => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'ssl-cert',
        'mode'    => '0640',
        'source'  => 'puppet:///modules/data/apache/ssl/ssl-private-tdb.key',
      },
      "${apache_ssl_cert}"              => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/data/apache/ssl/ec2.thedailybeast.com.pem',
      },
      "${apache_ssl_intermediate_cert}" => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/data/apache/ssl/gd_bundle.pem',
      },
      "${apache_ssl_intermediate_cert_tdb}" => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/data/apache/ssl/ssl-chain-tdb.pem',
      },
      "${apache_ssl_cert_tdb}"          => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/data/apache/ssl/thedailybeast.com.pem',
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
