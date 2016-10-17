# = Class: vsftpd::params
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
# class vsftpd::someclass( packages = $vsftpd::params::some_param
# ) inherits vsftpd::params {
# ...do something
# }
#
# class { 'vsftpd::params' : }
#
# include vsftpd::params
#
class vsftpd::params {

$supportedversion = '2.7'
$puppetversion = regsubst($::puppetversion, '^(\d+)\.(\d+)\.(\d+)$', '\1.\2')

if (versioncmp($puppetversion,$supportedversion) < 0 ) {
  fail("Module ${module_name} supports vsftpd version >= ${supportedversion}")
}

case $::operatingsystem {
  /Debian|Ubuntu/: {
    # Set sane defaults if no facts available for override
    $vsftpd_listen = $::vsftpd_listen ? {
      /true|false|yes|no/   => $::vsftpd_listen,
      default               => true,
    }

    $vsftpd_port_enable = $::vsftpd_port_enable ? {
      /true|false|yes|no/   => $::vsftpd_port_enable,
      default               => true,
    }

    $vsftpd_connect_from_port_20 = $::vsftpd_connect_from_port_20 ? {
      /true|false|yes|no/   => $::vsftpd_connect_from_port_20,
      default               => true,
    }

    $vsftpd_pasv_enable = $::vsftpd_pasv_enable ? {
      /true|false|yes|no/   => $::vsftpd_pasv_enable,
      default               => true,
    }

    $vsftpd_dirlist_enable = $::vsftpd_dirlist_enable ? {
      /true|false|yes|no/   => $::vsftpd_dirlist_enable,
      default               => true,
    }

    $vsftpd_lock_upload_files = $::vsftpd_lock_upload_files ? {
      /true|false|yes|no/   => $::vsftpd_lock_upload_files,
      default               => true,
    }

    $vsftpd_chmod_enable = $::vsftpd_chmod_enable ? {
      /true|false|yes|no/   => $::vsftpd_chmod_enable,
      default               => true,
    }

    $vsftpd_mdtm_write = $::vsftpd_mdtm_write ? {
      /true|false|yes|no/   => $::vsftpd_mdtm_write,
      default               => true,
    }

    $vsftpd_download_enable = $::vsftpd_download_enable ? {
      /true|false|yes|no/   => $::vsftpd_download_enable,
      default               => true,
    }

    $vsftpd_dirmessage_enable = $::vsftpd_dirmessage_enable ? {
      /true|false|yes|no/   => $::vsftpd_dirmessage_enable,
      default               => true,
    }

    $vsftpd_use_sendfile = $::vsftpd_use_sendfile ? {
      /true|false|yes|no/   => $::vsftpd_use_sendfile,
      default               => true,
    }

    $vsftpd_use_localtime = $::vsftpd_use_localtime ? {
      /true|false|yes|no/   => $::vsftpd_use_localtime,
      default               => true,
    }

    $vsftpd_userlist_deny = $::vsftpd_userlist_deny ? {
      /true|false|yes|no/   => $::vsftpd_userlist_deny,
      default               => true,
    }

    $vsftpd_anon_world_readable_only = $::vsftpd_anon_world_readable_only ? {
      /true|false|yes|no/   => $::vsftpd_anon_world_readable_only,
      default               => true,
    }

    $vsftpd_ssl_request_cert = $::vsftpd_ssl_request_cert ? {
      /true|false|yes|no/   => $::vsftpd_ssl_request_cert,
      default               => true,
    }

    $vsftpd_require_ssl_reuse = $::vsftpd_require_ssl_reuse ? {
      /true|false|yes|no/   => $::vsftpd_require_ssl_reuse,
      default               => true,
    }

    $vsftpd_force_local_data_ssl = $::vsftpd_force_local_data_ssl ? {
      /true|false|yes|no/   => $::vsftpd_force_local_data_ssl,
      default               => true,
    }

    $vsftpd_force_local_logins_ssl = $::vsftpd_force_local_logins_ssl ? {
      /true|false|yes|no/   => $::vsftpd_force_local_logins_ssl,
      default               => true,
    }

    $vsftpd_ssl_tlsv1 = $::vsftpd_ssl_tlsv1 ? {
      /true|false|yes|no/   => $::vsftpd_ssl_tlsv1,
      default               => true,
    }

    $vsftpd_xferlog_enable = $::vsftpd_xferlog_enable ? {
      /true|false|yes|no/   => $::vsftpd_xferlog_enable,
      default               => true,
    }

    # Resource defaults
    $vsftpd_package_defaults = {
      'ensure'    => 'latest',
      'provider'  => 'apt',
      'tag'       => 'vsftpd-package',
    }
    $vsftpd_services = {
      'vsftpd' => {
        'ensure'  => 'running',
        'enable'  => true,
      }
    }
    $vsftpd_packages = {
      'vsftpd'        => {},
    }
    $vsftpd_configs = {
      '/etc/vsftpd.conf'                      => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('vsftpd/Ubuntu/precise/vsftpd.conf.erb'),
          default   => template('vsftpd/Ubuntu/vsftpd.conf.erb'),
        },
      },
      '/etc/default/vsftpd'                   => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('vsftpd/Ubuntu/precise/default.erb'),
          default   => template('vsftpd/Ubuntu/default.erb'),
        },
      },
      '/etc/vsftpd.d'                         => {
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      },
      '/etc/vsftpd.d/vsftpd.chroot_users'     => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('vsftpd/Ubuntu/precise/chroot_users.erb'),
          default   => template('vsftpd/Ubuntu/chroot_users.erb'),
        },
      },
      '/etc/vsftpd.d/vsftpd.banned_emails'    => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('vsftpd/Ubuntu/precise/banned_emails.erb'),
          default   => template('vsftpd/Ubuntu/banned_emails.erb'),
        },
      },
      '/etc/vsftpd.d/vsftpd.email_passwords'  => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('vsftpd/Ubuntu/precise/email_passwords.erb'),
          default   => template('vsftpd/Ubuntu/email_passwords.erb'),
        },
      },
      '/etc/vsftpd.d/vsftpd.userlist_file'    => {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'content' => $::lsbdistcodename ? {
          'precise' => template('vsftpd/Ubuntu/precise/userlist_file.erb'),
          default   => template('vsftpd/Ubuntu/userlist_file.erb'),
        },
      },
    }
  }
  default: {
    fail("Module ${module_name} does not support ${::operatingsystem}")
  }
}
}
